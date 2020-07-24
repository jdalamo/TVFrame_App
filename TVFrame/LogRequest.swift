//
//  LogRequest.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/19/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

enum LogError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct LogRequest {
    let url: URL
    
    init() {
        let url_end = "log/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func getLog(completion: @escaping(Result<String, LogError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let logResponse = try decoder.decode(LogResponse.self, from: jsonData)
                let log = logResponse.response
                completion(.success(log))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
