//
//  ImageFetcher.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/24/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import Foundation
import UIKit

class ImageFetcher {
    
    /// We store all ongoing tasks here to avoid duplicating tasks.
    fileprivate var tasks = [URLSessionTask]()
    
    fileprivate let imageCache = NSCache<AnyObject,AnyObject>()
    
    func checkCache(endPoint: String) -> UIImage? {
        let cachedImage = imageCache.object(forKey: endPoint as AnyObject) as? UIImage
        return cachedImage
    }
    
    func loadImage(for server: String, id:String, secret:String, sizeParam: Bool = false, completion: @escaping (UIImage?) -> Void )  {
        
        let url =  "https://farm6.staticflickr.com/" + "\(server)/" + "\(id)_\(secret).jpg"
        guard let endPoint = URL.init(string: url) else { return  }
        
        
        guard let imageToCache = checkCache(endPoint: url) else  {
            //self.image = imageToCache
            return
        }
        
        let task = URLSession.shared.dataTask(with: endPoint) { (data, response, error) in
            DispatchQueue.main.async {
                if let imageData = data {
                    guard let imageToCache = UIImage(data: imageData as Data) else {
                        //self.image = UIImage(named: "placeholder.png")!.scaleImageToSize(newSize: CGSize(width: 800, height: 400))
                        return
                    }
                    self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    completion(imageToCache)
                }
            }
        }
        task.resume()
        tasks.append(task)
    }
    
    func cancelDownloadingImage(url : String) {
        //get the index of the item
        
        guard let u = URL.init(string: url) else { return }
        guard let taskIndex = tasks.index(where: { $0.originalRequest?.url == u }) else {
          return
        }
        
        let task = tasks[taskIndex]
        task.cancel()
        tasks.remove(at: taskIndex)
    }
}
