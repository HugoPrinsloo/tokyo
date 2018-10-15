//
//  FeedCollectionViewCell.swift
//  Tokyo
//
//  Created by Hugo Prinsloo on 2018/10/14.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(for item: SharedFile) {
        if let item = item as? Image {
            imageView.image = item.image
        }
    }

}
