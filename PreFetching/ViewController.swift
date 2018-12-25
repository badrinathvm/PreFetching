//
//  ViewController.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/23/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let reuseIdentifier = "displayCell"
    
    var dataSource:CustomDataSource<PhotoViewModel>?
    private var photoListViewModel: PhotoListViewModel?
    
    var imageFetcher = ImageFetcher()
    
    lazy var collectionView: UICollectionView = {
        let layout  = ColumnFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.prefetchDataSource  = self
        cv.register(DisplayCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(collectionView)
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.layer.borderColor = UIColor.black.cgColor
        // Set the collection view's prefetching data source.
        //collectionView.prefetchDataSource = dataSource
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        displayPhotoList()
    }
    
    
    private func displayPhotoList() {
        photoListViewModel = PhotoListViewModel(service: Service(), completion: {
            guard let viewModels = self.photoListViewModel?.photoViewModels else { return }
            self.dataSource = CustomDataSource.make(for: viewModels, reuseIdentifier: self.reuseIdentifier)
            self.collectionView.dataSource = self.dataSource
            self.collectionView.reloadData()
        })
    }
}


extension CustomDataSource where Item == PhotoViewModel {
    
    static func make(for items : [Item] , reuseIdentifier: String )  -> CustomDataSource {
        let dataSource = CustomDataSource(items: items, reuseIdentifier: reuseIdentifier) { (cell, model,imageFetcher) in
            //render the content
            let _cell = cell as! DisplayCell
            
            let photo = model.photo
            let url =  "https://farm6.staticflickr.com/" + "\(photo.server)/" + "\(photo.id)_\(photo.secret).jpg"
            guard let cachedImage  = imageFetcher.checkCache(endPoint: url) else {

                imageFetcher.loadImage(for: photo.server, id: photo.id, secret: photo.secret, completion: { (image) in
                    _cell.mainImage.image = image
                })
                
                return
            }
            _cell.configure(with: model)
            _cell.mainImage.image = cachedImage
        }
        
        return dataSource
    }
}



extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Index is \(indexPath.row)")
    }
}

extension ViewController : UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //Beging asyncronoulsy fetching data fror photo models
        guard let viewModels = self.photoListViewModel?.photoViewModels else {
            print("Out")
            return
        }
        
        print("Prefetching ::\(indexPaths)")
        
        indexPaths.forEach { index in
            let photo = viewModels[index.row].photo
            self.imageFetcher.loadImage(for: photo.server, id: photo.id, secret: photo.secret, completion: { (image) in
             })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
       
        //Beging asyncronoulsy fetching data fror photo models
        guard let viewModels = self.photoListViewModel?.photoViewModels else {
            print("Out")
            return
        }
        
        print("Cancelling Pre Fetch :: \(indexPaths)")
        
        indexPaths.forEach { (index) in
             let photo = viewModels[index.row].photo
             let url =  "https://farm6.staticflickr.com/" + "\(photo.server)/" + "\(photo.id)_\(photo.secret).jpg"
            self.imageFetcher.cancelDownloadingImage(url: url)
        }
        
        
    }
    
    
    
}

