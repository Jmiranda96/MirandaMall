//
//  ItemListModel.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 8/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import Foundation

protocol ItemListDelegate {
    func setItems()
    func noResults()
    func errorInRequest()
    func stopLoader()
}

class ItemListModel {

    let mlServices = MLServices()
    var delegate: ItemListDelegate!
    var itemList = [MLServices.MLSearchResult]()

    func getItems(byCategory cat: String = "", bySearch q: String = "", newPage: Bool = false){
        mlServices.fetchItems(byCategory: cat, bySearch: q, isNewPage: newPage) { (items, error) in
            
            guard items != nil || error == nil else {
                self.delegate.errorInRequest()
                return
            }
            
            guard items!.results!.count > 0 else {
                guard !newPage else {
                    self.delegate.stopLoader()
                    return
                }
                self.delegate.noResults()
                return
            }
            
            if newPage {
                self.itemList += items!.results!
            } else {
                self.itemList = items!.results!
            }
            
            self.delegate.setItems()
            
        }
    }
    
}
