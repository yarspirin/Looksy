//
//  Network.swift
//  Looksy
//
//  Created by Yaroslav Spirin on 01/12/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class Network {
    public static func requestWith(url: String, imageData: Data?, parameters: [String : Any],
                                   onCompletion: ((SegmentationResult) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "img.jpg", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error {
                        onError?(err)
                        return
                    }
                    
                    guard let data = response.data else {
                        return
                    }
                    
                    let json = try! JSON(data: data)
                    guard let segmentedImageURL = json["segmented"].string,
                        let recommended = json["recommend"].dictionary else {
                        return
                    }
                    
                    var itemCollections = [ItemCollection]()
                    
                    recommended.forEach {
                        if var itemCollection = ItemCollection(json: $1) {
                            itemCollection.title = $0
                            itemCollections.append(itemCollection)
                        }
                    }
                    
                    var segmentationResult = SegmentationResult(segmentedImageURLString: segmentedImageURL, itemCollections: itemCollections)
                    
                    if let url = URL(string: segmentationResult.segmentedImageURLString) {
                        segmentationResult.segmentedImage = UIImage.load(url: url)
                    }
                    
                    onCompletion?(segmentationResult)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
