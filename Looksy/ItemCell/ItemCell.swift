//
//  ItemCell.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 01/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    
    public func configureCell(with image: UIImage) {
        self.itemImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class var reuseIdentifier: String {
        return "ItemCell"
    }
    
    class var nibName: String {
        return "ItemCell"
    }
}
