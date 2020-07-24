//
//  ViewController.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var picsButton: UIButton!
    
    var name: DeviceName? {
        didSet {
            DispatchQueue.main.async {
                self.navItem.title = self.name?.device_name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getName()
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let largeImage = UIImage(systemName: "folder", withConfiguration: largeConfig)
        self.picsButton.setImage(largeImage, for: .normal)
    }
    
    func getName() {
        let nameRequest = NameRequest()
        nameRequest.getName { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let name):
                self?.name = name
            }
        }
    }
    
    @IBAction func didTapSettingsButton() {
        let vc = storyboard?.instantiateViewController(identifier: "settings_vc") as! SettingsViewController
        vc.presentationController?.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func didTapPhotosButton() {
        let vc = storyboard?.instantiateViewController(identifier: "photos_vc") as! PhotosViewController
        present(vc, animated: true)
    }
    
    @IBAction func didTapDownloadButton() {
        let url_end = "download_photos/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in}
        dataTask.resume()
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        getName()
    }
}
