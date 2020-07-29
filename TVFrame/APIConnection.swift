//
//  APIConnection.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/19/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

struct APIConnection {
    var IPAddress: String
    var baseURLString: String
    var baseURL: URL
    
    init() {
        IPAddress = UserDefaults.standard.string(forKey: "ServerIpAddress") ?? "None"
        baseURLString = "http://\(IPAddress):5000/"
        baseURL = URL(string: baseURLString)!
    }
}
