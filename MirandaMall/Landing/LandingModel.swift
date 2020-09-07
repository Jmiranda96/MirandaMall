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
    
    let mlServices = MLServices()
    var delegate: LandingDelegate!
    var catList = [MLServices.MLCategoryDetails]()
    
    func getCategories() {
        // fetch categories from mlServices
        mlServices.fetchCategories { (list) in
            // the image url of each category is fetched by id
            list.forEach { (info) in
                self.mlServices.fetchDetailCategory(info.id) { detail in
                    self.catList.append(MLServices.MLCategoryDetails(id: detail.id, name: detail.name, picture: detail.picture))
                    // the delegate function is called to update collection data on viewController
                    self.delegate.setCategories()
                }
            }
            
        }
    }
    
}
