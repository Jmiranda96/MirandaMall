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
    
    var sessionManager: Session?
    
    enum RequestError: Error {
        case invalidStatus
        case errorInRequest
        var errorDescription: String? {
            switch self {
            case .invalidStatus:
                return "invalidStatus"
            case .errorInRequest:
                return "errorInRequest"
            }
        }
    }
    
    init(session: Session? = Session()) {
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
        
        // Init of session manager (mock purposes)
        
        self.sessionManager = session
    }
    
    /// function to fetch list of categories available in region
    func fetchCategories(closure: @escaping  ([MLCategoryDetails]?, RequestError?) -> Void) {
        
        guard let session = sessionManager else {
            print("NIL SESSION MANAGER")
            return
        }
        
        session.request("\(self.mlUrl)sites/\(self.regionCode)/categories").responseDecodable(of: [MLCategoryDetails].self) { (response) in
            
            guard response.response?.statusCode == 200 else {
                closure( nil, RequestError.invalidStatus)
                return
            }
            
            guard response.error == nil else {
                closure( nil, RequestError.errorInRequest)
                return
            }
            
            guard let categories = response.value else { return }
            closure(categories, nil)
        }
    }
    
    /// fetch detail of category by his id
    func fetchDetailCategory(_ id: String, closure: @escaping  (MLCategoryDetails?, RequestError?) -> Void) {
        
        guard let session = sessionManager else {
            print("NIL SESSION MANAGER")
            return
        }
        
        session.request("\(self.mlUrl)categories/\(id)").responseDecodable(of: MLCategoryDetails.self) { (response) in

            guard response.response?.statusCode == 200 else {
                closure( nil, RequestError.invalidStatus)
                return
            }
            
            guard response.error == nil else {
                closure( nil, RequestError.errorInRequest)
                return
            }
            
            guard let details = response.value else { return }
            closure(details, nil)
        }
    }
    
    struct MLCategoryDetails: Codable, Equatable {
        var id: String? = ""
        var name: String? = ""
        var picture: String? = ""
    }
    
}
