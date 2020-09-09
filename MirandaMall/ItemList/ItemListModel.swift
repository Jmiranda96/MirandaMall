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
}

class ItemListModel {

    let mlServices = MLServices()
    var delegate: ItemListDelegate!
    var itemList = [MLServices.MLSearchResult]()

    func getItems(byCategory cat: String = "", bySearch q: String = ""){
        mlServices.fetchItems(byCategory: cat, bySearch: q) { (items, error) in
            
            guard items != nil || error == nil else {
                self.delegate.errorInRequest()
                return
            }
            
            guard items!.results!.count > 0  else {
                self.delegate.noResults()
                return
            }
            
            self.itemList = items!.results!
            self.delegate.setItems()
            
        }
    }
    
}
