//
//  Item.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 01/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Item {
    let name: String
    let brand: String
    let imageURLString: String
    let image: UIImage?
    let marketURLString: String
    let type: String
    let source: String
    let price: String
    
    init?(json: JSON) {
        self.name = json["name"].stringValue
        self.brand = json["brand"].stringValue
        self.imageURLString = json["img"].stringValue
        self.marketURLString = json["url"].stringValue
        self.type = json["type"].stringValue
        self.source = json["source"].stringValue
        self.price = json["price"].stringValue
        
        if let url = URL(string: imageURLString) {
            image = UIImage.load(url: url)
        } else {
            image = nil
        }
    }
}
