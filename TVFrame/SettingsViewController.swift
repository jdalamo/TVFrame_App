//
//  SettingsViewController.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var deviceNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var modeButton: UIButton!
    
    
    var settings: PiSettings? {
        didSet {
            DispatchQueue.main.async {
                self.deviceNameField.text = self.settings?.device_name
                self.emailField.text = self.settings?.email
                self.modeButton.setTitle(self.settings?.mode, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceNameField.delegate = self
        emailField.delegate = self
        
        getSettings()
        
        initializeHideKeyboard()
        
    }
    
    func getSettings() {
        let settingsRequest = SettingsRequest()
        settingsRequest.getSettings { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let piSettings):
                self?.settings = piSettings
            }
        }
    }
    
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    func updateSetting(name: String, email: String) -> Void {
        let url_end = "settings/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        
        struct DataDict: Codable {
            let newName: String
            let newEmail: String
        }

        struct UploadData: Codable {
            let data: DataDict
        }
        let uploadDict = DataDict(newName: name, newEmail: email)
        let uploadDataModel = UploadData(data: uploadDict)
        
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
    
    @IBAction func didTapModeButton() {
        let vc = storyboard?.instantiateViewController(identifier: "modes_vc") as! ModesViewController
        vc.presentationController?.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func didTapLogButton() {
        let vc = storyboard?.instantiateViewController(identifier: "log_vc") as! LogViewController
        present(vc, animated: true)
        
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        getSettings()
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateSetting(name: deviceNameField.text!, email: emailField.text!)
        return false
    }
}
