//
//  InspirationCell.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 30/11/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit
import PinterestLayout

class InspirationCell: UICollectionViewCell {
    
    enum LikeState {
        case liked
        case notLiked
    }
    
    @IBAction func starButtonTapped(_ sender: UIButton) {
        guard let earlyStar = UIImage(named: "star-early"),
            let lateStar = UIImage(named: "star-late") else {
                return
        }
        
        switch likeState {
        case .liked:
            starButton.setImage(earlyStar, for: .normal)
            likeState = .notLiked
        case .notLiked:
            starButton.setImage(lateStar, for: .normal)
            likeState = .liked
        }
    }
    
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var starContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var likeState: LikeState = .notLiked
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            } else {
                imageView.backgroundColor = .lightGray
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.imageHeight
        }
    }
}
