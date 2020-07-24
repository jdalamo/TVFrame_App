//
//  PhotosDownload.swift
//  TVFrame
//
//  Created by JD del Alamo on 7/21/20.
//  Copyright © 2020 JD del Alamo. All rights reserved.
//

import Foundation

struct PhotosDownload {
    let url: URL
    
    init() {
        let url_end = "download_photos/"
        let conn = APIConnection()
        let url = conn.baseURL.appendingPathComponent(url_end)
        self.url = url
    }
    
    func download() {
        let dataTask = URLSession.shared.dataTask(with: url) {data, _, _ in}
        dataTask.resume()
    }
}
