//
//  DeviceName.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/18/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

struct NameResponse: Decodable {
    var response: DeviceName
}

struct DeviceName: Decodable {
    var device_name: String
}
