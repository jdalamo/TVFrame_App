//
//  NameRequest.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/18/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

enum NameError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct NameRequest {
    let url: URL
    
    init() {
        let url_end = "name/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func getName(completion: @escaping(Result<DeviceName, SettingsError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let nameResponse = try decoder.decode(NameResponse.self, from: jsonData)
                let name = nameResponse.response
                completion(.success(name))
            } catch {
                completion(.failure(.cannotProcessData))
            }
            
        }
        dataTask.resume()
    }
}
