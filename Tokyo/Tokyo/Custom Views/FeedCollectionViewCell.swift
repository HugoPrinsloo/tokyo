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
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleBackgroundView.layer.cornerRadius = 16
        titleBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setup()
    }
    
    func configure(for item: SharedFile) {
        if let item = item as? Image {
            imageView.image = item.image
        }
    }
    
    private func setup() {
        backgroundColor = UIColor.lightGray
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 16
        layer.cornerRadius = 16
    }
}

