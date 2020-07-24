//
//  LogViewController.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/19/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet weak var logTextView: UITextView!
    
    var log: String? {
        didSet {
            DispatchQueue.main.async {
                self.logTextView.text = self.log
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getLog()
    }
    
    func getLog() {
        let logRequest = LogRequest()
        logRequest.getLog { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let log):
                if log == "" {
                    self?.log = "Empty log file."
                } else {
                    self?.log = log
                }
            }
        }
    }
}
