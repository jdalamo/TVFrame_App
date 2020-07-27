//
//  Settings.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

struct SettingsResponse: Decodable {
    var response: PiSettings
}

struct PiSettings: Decodable {
    var device_name: String
    var mode: String
}
