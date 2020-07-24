//
//  SettingsRequest.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

enum SettingsError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct SettingsRequest {
    let url: URL
    
    init() {
        let url_end = "settings/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func getSettings(completion: @escaping(Result<PiSettings, SettingsError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let settingsResponse = try decoder.decode(SettingsResponse.self, from: jsonData)
                let settings = settingsResponse.response
                completion(.success(settings))
            } catch {
                completion(.failure(.cannotProcessData))
            }
            
        }
        dataTask.resume()
    }
}

