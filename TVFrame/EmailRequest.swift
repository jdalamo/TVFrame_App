//
//  EmailRequest.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/27/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

enum EmailError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct EmailRequest {
    let url: URL
    
    init() {
        let url_end = "email/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func getEmail(completion: @escaping(Result<String, EmailError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let emailResponse = try decoder.decode(EmailResponse.self, from: jsonData)
                let email = emailResponse.response
                completion(.success(email))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
