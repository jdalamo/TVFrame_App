//
//  ModesRequest.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/17/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

enum ModesError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct ModesRequest {
    let url: URL
    
    init() {
        let url_end = "modes/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func getModes(completion: @escaping(Result<[Mode], ModesError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let modesResponse = try decoder.decode(ModesResponse.self, from: jsonData)
                let modes = modesResponse.response
                completion(.success(modes))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
