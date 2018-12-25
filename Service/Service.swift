//
//  Service.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/23/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import Foundation

enum Result<Photo> {
    case success(Photo)
    case failure(Error)
}

class Service {
    
    func fetchPhotoData(completion :  @escaping (Result<[Photo]>) -> ()) {
        
        let endPoint = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=fee10de350d1f31d5fec0eaf330d2dba&per_page=500&format=json&nojsoncallback=true"
        
        guard let url = URL.init(string: endPoint) else { return }
        
        let session  = URLSession.init(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }else if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        let photos = try decoder.decode(PhotoData.self, from: jsonData).photos.photo
                        completion(.success(photos))
                    }catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}
