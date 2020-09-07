//
//  UrlImageView.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 7/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit
import Alamofire

class UrlImageView: UIImageView {
    

    let imageCache = NSCache<NSString, UIImage>()
    var imageUrlString = String()
    
    func loadImageFromUrl(_ urlString: String){
        imageUrlString = urlString
        
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        AF.download(urlString).responseData { response in
            
            guard response.error == nil else {
                return
            }
            
            if let data = response.value {
                let imageToCache = UIImage(data: data)
                guard imageToCache != nil else {
                    self.image = UIImage(named: "MMLogo")
                    return
                }
                DispatchQueue.main.async {
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                }
                self.imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
        }
    }
}
