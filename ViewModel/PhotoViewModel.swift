//
//  PhotoViewModel.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/23/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import Foundation

class PhotoListViewModel {
    
    private(set) var photoViewModels = [PhotoViewModel]()
    
    typealias Handler = () -> ()
    var service:Service
    var completion:Handler
    
    init(service: Service, completion: @escaping Handler ) {
        self.service = service
        self.completion = completion
        fetchData()
    }

    private func fetchData() {
        service.fetchPhotoData { (photos) in
            if case .success(let photos) = photos {
                self.photoViewModels = photos.map(PhotoViewModel.init)
                self.completion()
            }
        }
    }
    
    
    func refreshModel(completion: @escaping([PhotoViewModel]) -> ()) {
        service.fetchPhotoData { (photos) in
            if case .success(let photos) = photos {
                self.photoViewModels = photos.map(PhotoViewModel.init)
                //self.completion()
                completion(self.photoViewModels)
            }
        }
    }
}

class PhotoViewModel {
    var photo:Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
}
