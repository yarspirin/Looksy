//
//  ItemCollection.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 02/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemCollection {
    let image: UIImage?
    let imageURLString: String
    var title: String?
    let items: [Item?]

    init?(json: JSON) {
        self.title = nil
        self.imageURLString = json["img"].stringValue
        self.items = json["items"].arrayValue.map {
            Item(json: $0)
        }
        
        if let url = URL(string: imageURLString) {
            image = UIImage.load(url: url)
        } else {
            image = nil
        }
    }
}
