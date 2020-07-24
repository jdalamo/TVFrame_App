//
//  Modes.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

struct ModesResponse: Decodable {
    var response: [Mode]
}

struct Mode: Decodable {
    var name: String
    var active: Bool
}
