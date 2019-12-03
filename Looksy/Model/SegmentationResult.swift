//
//  SegmentationResult.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 02/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import Foundation

struct SegmentationResult {
    let segmentedImageURLString: String
    var segmentedImage: UIImage?
    let itemCollections: [ItemCollection]
}
