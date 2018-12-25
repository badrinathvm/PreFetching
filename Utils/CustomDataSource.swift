//
//  CustomDataSource.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/23/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import Foundation
import UIKit

class CustomDataSource<Item>: NSObject, UICollectionViewDataSource {
    
    
    var imageFetcher = ImageFetcher()
    
    typealias Handler  = (UICollectionViewCell, Item, ImageFetcher) -> Void
    var items:[Item]
    var reuseIdentifier: String
    var handler: Handler
    

    
    init(items: [Item] , reuseIdentifier: String, handler: @escaping Handler ) {
        self.items = items
        self.reuseIdentifier = reuseIdentifier
        self.handler = handler
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        handler(cell, model,imageFetcher)
        
        return cell
    }
}
