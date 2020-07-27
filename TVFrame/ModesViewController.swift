//
//  ModesViewController.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit

class ModesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var modesTableView: UITableView!
    
    var modes: [Mode]!
    var loading = true
    var userHasSelected = false
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modesTableView.register(ModeTableViewCell.nib(), forCellReuseIdentifier: ModeTableViewCell.identifier)
        
        modesTableView.delegate = self
        modesTableView.dataSource = self
        
        getModes()
        
    }
    
    func getModes() -> Void {
        let modesRequest = ModesRequest()
        modesRequest.getModes { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let modes):
                self?.modes = modes
                self?.loading = false
                DispatchQueue.main.async {
                    self?.modesTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 1
        } else {
            return modes.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModeTableViewCell.identifier, for: indexPath) as! ModeTableViewCell
        cell.selectionStyle = .none
        if loading {
            cell.configure(with: "Loading...", imageName: "")
        } else {
            let mode = modes[indexPath.row]
            if userHasSelected {
                if selectedRow == indexPath.row {
                    cell.configure(with: mode.name, imageName: "circle.fill")
                } else {
                    cell.configure(with: mode.name, imageName: "circle")
                }
            } else {
                if mode.active {
                    cell.configure(with: mode.name, imageName: "circle.fill")
                }
                else {
                    cell.configure(with: mode.name, imageName: "circle")
                }
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userHasSelected = true
        selectedRow = indexPath.row
        let name = modes[indexPath.row].name
        changeMode(newMode: name)
        modesTableView.reloadData()
    }
    
    func changeMode(newMode: String) -> Void {
        let url_end = "modes/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        
        struct UploadData: Codable {
            let data: String
        }
        
        let uploadDataModel = UploadData(data: newMode)
        
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("error encoding")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("error calling put")
                print(error!)
                return
            }
            guard let data = data else {
                print("did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print("http request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("cannot convert JSON object to pretty json data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("couldn't print json in string")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("error trying to convert json data to string")
                return
            }
            
        }.resume()
    }
}
