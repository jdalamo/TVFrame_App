//
//  PhotosViewController.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/19/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var photosTableView: UITableView!
    
    var photos: [String]!
    var loading = true
    
    let placeholderImage = UIImage(named: "placeholder")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosTableView.register(PhotosTableViewCell.nib(), forCellReuseIdentifier: PhotosTableViewCell.identifier)
        
        photosTableView.delegate = self
        photosTableView.dataSource = self

        getPhotos()
    }
    
    @objc private func refreshPhotos(_ sender: Any) {
        getPhotos()
    }
    
    func getPhotos() -> Void {
        let photosRequest = PhotosRequest()
        photosRequest.getPhotos { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let photos):
                self?.photos = photos
                self?.loading = false
                DispatchQueue.main.async {
                    self?.photosTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 1
        } else {
            return photos.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
        if loading {
            return cell
        } else {
            let filename = photos[indexPath.row]
            let conn = APIConnection()
            let baseURL = conn.baseURL.appendingPathComponent("pic/")
            let imageUrl = baseURL.appendingPathComponent(filename)
            cell.configure(with: filename, imageUrl: imageUrl)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        changeDisplayPhoto(filename: photo)
    }
    
    func changeDisplayPhoto(filename: String) -> Void {
        let url_end = "display_photo/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        
        struct UploadData: Codable {
            let data: String
        }
        
        let uploadDataModel = UploadData(data: filename)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePhoto(filename: photos[indexPath.row])
            photos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func deletePhoto(filename: String) {
        let url_end = "photos/\(filename)"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could not print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}
