//
//  LandingModel.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 6/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import Foundation

protocol LandingDelegate {
    func setCategories()
}

class LandingModel {
    
    var mlServices = MLServices()
    var delegate: LandingDelegate!
    var catList = [MLServices.MLCategoryDetails]()
    
    func getCategories() {
        // fetch categories from mlServices
        mlServices.fetchCategories { (list, error)  in
            
            // check for error in response
            guard error == nil else {
                return
            }
            
            // the image url of each category is fetched by id
            var index = 0
            list!.forEach { (info) in
                self.mlServices.fetchDetailCategory(info.id!) { (detail, error) in
                    index += 1
                    guard error == nil else {
                        return
                    }
                    self.catList.append(MLServices.MLCategoryDetails(id: detail!.id, name: detail!.name, picture: detail!.picture))
                    // the delegate function is called to update collection data on viewController after all the elements appends
                    if index >= list!.count {
                        self.delegate.setCategories()
                    }
                }
            }
        }
    }
    
}
