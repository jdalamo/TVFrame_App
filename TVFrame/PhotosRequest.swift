//
//  PhotosRequest.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/19/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

enum PhotosError: Error {
    case noDataAvailable
    case cannotProcessData
}

struct PhotosRequest {
    let url: URL
    
    init() {
        let url_end = "photos/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func getPhotos(completion: @escaping(Result<[String], PhotosError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photosResponse = try decoder.decode(PhotosResponse.self, from: jsonData)
                let photos = photosResponse.response
                completion(.success(photos))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
