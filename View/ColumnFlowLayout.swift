//
//  ColumnFlowLayout.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/23/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import Foundation
import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else  { return }
        
        let availableWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        let minColumnWidth = CGFloat(300.0)
        
        //get max number of columns instead of harcoding
        let maxColumns = Int(availableWidth/minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: 70.0)
        
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        
        self.sectionInsetReference = .fromSafeArea
    }
}
