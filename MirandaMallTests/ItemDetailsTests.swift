//
//  ItemDetailsTests.swift
//  MirandaMallTests
//
//  Created by Jorge Miranda on 10/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import XCTest
@testable import MirandaMall
import Alamofire
@testable import Mocker

import XCTest

class ItemDetailsTests: XCTestCase {

    var mainvc: ItemDetailsViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ItemDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ItemDetailsViewController") as! ItemDetailsViewController
        mainvc = vc
        mainvc.model.mlServices.sessionManager = nil
        _ = mainvc.view // To call viewDidLoad
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: mainvc)
        window.makeKeyAndVisible()
    }
    
    override func tearDown() {
        mainvc = nil
        window.rootViewController = nil
        super.tearDown()
    }
    
    func testGetDetails(){
        //GIVEN
        
        //Injection of mocked session
        mainvc.model.mlServices = MLServices(session: getMockedSession(), testing: true)
        
        //Mock of fetchCatalogs
        let apiEndpoint = URL(string: "https://api.mercadolibre.com/items/MCO468073609")!
        let expectedResponse = MLServices.MLItemResponse(title: "TestTitle", price: 123, condition: "new", permalink: "ml.com", sold_quantity: 100, pictures: [MLServices.MLPicture(secure_url: "test.jpg")], attributes: [MLServices.MLAttributes(name: "test1", value_name: "1"),MLServices.MLAttributes(name: "test1", value_name: "2")])
        let mockedData = try! JSONEncoder().encode(expectedResponse)
        let mockCat = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mockCat.register()
        
        //WHEN
        mainvc.model.delegate = mainvc
        mainvc.model.getDetails(id: "MCO468073609")
        let requestExpect = expectation(description: "request")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
           requestExpect.fulfill()
        }
        wait(for: [requestExpect], timeout: 7)
        
        //THEN
            //labels
        XCTAssertEqual(mainvc.itemTitle.text, expectedResponse.title)
        XCTAssertEqual(mainvc.itemPrice.text, String(expectedResponse.price!) + " COP")
        XCTAssertEqual(mainvc.mlURL, expectedResponse.permalink)
            //CollectionView
        XCTAssertEqual(mainvc.imageCollection.numberOfItems(inSection: 0), 1)
        
        let cellCollection = mainvc.collectionView(mainvc.imageCollection, cellForItemAt: IndexPath(row: 0, section: 0)) as! ItemDetailsCollectionViewCell
        XCTAssertEqual(cellCollection.url, "test.jpg")
        
            //TableView
        let cellTable = mainvc.tableView(mainvc.attributesTable, cellForRowAt: IndexPath(row: 0, section: 0)) as! ItemDetailsTableViewCell
        XCTAssertEqual(cellTable.attributeLabel.text, "test1")
        XCTAssertEqual(cellTable.valueLabel.text, "1")
        XCTAssertEqual(mainvc.attributesTable.numberOfRows(inSection: 0), 2)
        
        
    }

    func getMockedSession() -> Session{
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }
}
