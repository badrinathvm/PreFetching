//
//  DisplayCell.swift
//  PreFetching
//
//  Created by Badarinath Venkatnarayansetty on 12/23/18.
//  Copyright © 2018 Badarinath Venkatnarayansetty. All rights reserved.
//

import Foundation
import UIKit

class DisplayCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The `UUID` for the data this cell is presenting.
    var representedId: String?
    
    lazy var mainImage: UIImageView = { [unowned self] in
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
        }()
    
    private func setup() {
        
        self.contentView.addSubview(mainImage)
        
        NSLayoutConstraint.activate([
            self.mainImage.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            self.mainImage.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            self.mainImage.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            self.mainImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5)
        ])
    }
    
    func configure(with data: PhotoViewModel) {
        self.representedId = data.photo.id
    }
}
