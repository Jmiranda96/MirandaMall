//
//  ItemDetailsModel.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 9/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import Foundation

protocol ItemDetailsDelegate {
    func setDetails()
    func errorInRequest()
}

class ItemDetailsModel {
 
    var delegate: ItemDetailsDelegate!
    var mlServices = MLServices()
    var detailInfo = MLServices.MLItemResponse()
    
    func getDetails(id: String) {
        mlServices.fetchItemDetails(id: id) { (detailInfo, error) in
            guard detailInfo != nil || error == nil else {
               self.delegate.errorInRequest()
               return
            }
            
            self.detailInfo = detailInfo!
            
            self.delegate.setDetails()
            return
           }
        }
}
