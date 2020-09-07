//
//  MLServices.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 6/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import Foundation
import Alamofire
class MLServices {
    
    
    let regionCode: String
    let mlUrl: String
    
    init() {
        // get url direction from info.plist
        guard let serverUrl = Bundle.main.infoDictionary?["ml-api-url"] as? String  else {
            fatalError("ML api direction not found")
        }
        self.mlUrl = serverUrl
        
        // get region from info.plist
        guard let serverRegion = Bundle.main.infoDictionary?["ml-api-region"] as? String else {
            fatalError("ML api region not found")
        }
        self.regionCode = serverRegion
    }
    
    func fetchCategories(closure: @escaping  ([MLCategoryDetails]) -> Void) {
        AF.request("\(self.mlUrl)sites/\(self.regionCode)/categories").responseDecodable(of: [MLCategoryDetails].self) { (response) in
            
            guard response.error == nil else { return }
            
            guard let categories = response.value else { return }
            closure(categories)
        }
    }
    
    func fetchDetailCategory(_ id: String, closure: @escaping  (MLCategoryDetails) -> Void) {
        AF.request("\(self.mlUrl)categories/\(id)").responseDecodable(of: MLCategoryDetails.self) { (response) in

            guard response.error == nil else { return }
            
            guard let details = response.value else { return }
            closure(details)
        }
    }
    struct MLCategoryDetails: Decodable {
        var id: String
        var name: String
        var picture: String? = ""
    }
    
}
