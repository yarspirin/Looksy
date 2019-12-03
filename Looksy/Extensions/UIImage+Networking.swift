//
//  UIImage+Networking.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 02/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import Foundation

extension UIImage {
    static func load(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}

