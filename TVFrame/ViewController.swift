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
    
    var name: String? {
        didSet {
            DispatchQueue.main.async {
                self.navItem.title = self.name
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let testConnection = APIConnection()
        if testConnection.IPAddress == "None" {
            let vc = ScannerViewController()
            present(vc, animated: true)
        }
    }
    
    func getName() {
        let settingsRequest = SettingsRequest()
        settingsRequest.getSettings { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let settings):
                self?.name = settings.device_name
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
    
    @IBAction func didTapScannerButton() {
        let vc = ScannerViewController()
        present(vc, animated: true)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        getName()
    }
}

