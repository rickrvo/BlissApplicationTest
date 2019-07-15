//
//  Extensions.swift
//  BlissApplicationsTest
//
//  Created by Henrique Ormonde on 13/07/19.
//  Copyright © 2019 Rick. All rights reserved.
//

import Foundation
import UIKit

func toJSON(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}


// MARK : - Images

let imageCacheExtension = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        if let imageFromCache = imageCacheExtension.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil { return }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    if let image = UIImage(data: data!) {
                        imageCacheExtension.setObject(image, forKey: urlString as AnyObject)
                        self.image = image
                    }
                })
                
            }).resume()
        }
    }
    
}
