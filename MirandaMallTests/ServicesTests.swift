//
//  ServicesTests.swift
//  MirandaMallTests
//
//  Created by Jorge Miranda on 7/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import XCTest
import Alamofire
@testable import Mocker
@testable import MirandaMall


class ServicesTests: XCTestCase {

   
    
    struct User: Codable, Equatable {
        let name: String
    }
    
    func testSuccessCategoriesListFetching() {
        // Session config
        let mlService = MLServices(session: getMockedSession())

        //GIVEN
        let apiEndpoint = URL(string: "https://api.mercadolibre.com/sites/MCO/categories")!
        let expectedResponse = [MLServices.MLCategoryDetails(id: "1234", name: "testCategory", picture: "123.jpg")]
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(expectedResponse)
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        //WHEN
        mlService.fetchCategories { (result, _) in
            requestExpectation.fulfill()
            
            //THEN
            XCTAssertEqual(result, expectedResponse)
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testWrongDataCategoriesListFetching() {
        // Session config
        let mlService = MLServices(session: getMockedSession())
        
        // GIVEN
        let apiEndpoint = URL(string: "https://api.mercadolibre.com/sites/MCO/categories")!
        let expectedResponse = ""
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(expectedResponse)
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        //WHEN
        mlService.fetchCategories { (result, error) in
            requestExpectation.fulfill()
            
            //THEN
            XCTAssertTrue(error!.errorDescription == MLServices.RequestError.errorInRequest.errorDescription)
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testFailureCodeCategoriesListFetching() {
        // Session config
        let mlService = MLServices(session: getMockedSession())
        
        // GIVEN
        let apiEndpoint = URL(string: "https://api.mercadolibre.com/sites/MCO/categories")!
        let expectedResponse = MLServices.MLCategoryDetails()
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(expectedResponse)
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 404, data: [.get: mockedData])
        mock.register()
        
        //WHEN
        mlService.fetchCategories { (result, error) in
            requestExpectation.fulfill()
            
            //THEN
            XCTAssertTrue(error!.errorDescription == MLServices.RequestError.invalidStatus.errorDescription)
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testSuccessDetailFetching() {
        // Session config
        let mlService = MLServices(session: getMockedSession())

        // GIVEN
        let apiEndpoint = URL(string: "https://api.mercadolibre.com/categories/MLA5725")!
        let expectedResponse = MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "123.jpg")
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(expectedResponse)
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        // WHEN
        mlService.fetchDetailCategory("MLA5725") { (result, _) in
            requestExpectation.fulfill()
            
            // THEN
            XCTAssertEqual(result, expectedResponse)
        }
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func getMockedSession() -> Session{
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }

}
