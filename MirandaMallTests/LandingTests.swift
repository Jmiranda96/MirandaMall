//
//  LandingTests.swift
//  MirandaMallTests
//
//  Created by Jorge Miranda on 7/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import XCTest
@testable import MirandaMall
import Alamofire
@testable import Mocker


class LandingTests: XCTestCase {

    var mainvc: LandingViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LandingViewController = storyboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
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
    
    func testAppearance() {
        let logo: UIImage = #imageLiteral(resourceName: "MMLogo")
        XCTAssertEqual(mainvc.logoImage.image?.pngData(), logo.pngData())
        XCTAssertNotNil(mainvc.searchBar)
        
    }
    
    func testSegueCategory() {
        //GIVEN
        mainvc.model.catList = [
             MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png"),
             MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png"),
             MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png")]
        
        
        //WHEN
        self.mainvc.setCategories()
        
        mainvc.collectionView(mainvc.categoryCollection, didSelectItemAt: IndexPath(row: 0, section: 0))
        
        let expectationSegue = expectation(description: "Segue")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectationSegue.fulfill()
        }
        wait(for: [expectationSegue], timeout: 4)
        
        //THEN
        guard let nextVc = mainvc.navigationController?.topViewController as? ItemListViewController else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(nextVc.query, "")
        XCTAssertEqual(nextVc.categoryInfo, mainvc.model.catList.first)
        XCTAssertTrue(nextVc.isKind(of: ItemListViewController.self))
        
    }
    
    func testSegueSearch() {
        //GIVEN
        mainvc.searchBar.text = "Test"
        
        //WHEN
        mainvc.searchBarSearchButtonClicked(mainvc.searchBar)
        
        let expectationSegue = expectation(description: "Segue")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectationSegue.fulfill()
        }
        wait(for: [expectationSegue], timeout: 4)
        
        //THEN
        guard let nextVc = mainvc.navigationController?.topViewController as? ItemListViewController else {
            XCTFail()
            return
        }
        XCTAssertEqual(nextVc.query, "Test")
        XCTAssertEqual(nextVc.categoryInfo, MLServices.MLCategoryDetails())
        XCTAssertTrue(nextVc.isKind(of: ItemListViewController.self))
        
    }
    
    func testColeccionCellContent(){
        //GIVEN
        mainvc.model.catList = [
            MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png"),
            MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png"),
            MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png")]
       
        //WHEN
        self.mainvc.setCategories()
        let requestExpectation = expectation(description: "UI Refresh")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            requestExpectation.fulfill()
        }
        
        wait(for: [requestExpectation], timeout: 4)
        
        let cell = mainvc.collectionView(mainvc.categoryCollection, cellForItemAt: IndexPath(row: 0, section: 0)) as! CategoryCollectionViewCell
        //THEN
        XCTAssertEqual(mainvc.categoryCollection.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(cell.mainLabel.text, mainvc.model.catList[0].name)
    }
    
    func testCollectionCellOrientation(){
        
        //GIVEN
         mainvc.model.catList = [
             MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png")
        ]
        self.mainvc.setCategories()
        
        let requestExpectation = expectation(description: "UI Refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            requestExpectation.fulfill()
        }
        wait(for: [requestExpectation], timeout: 4)
        
        let cellPrior = mainvc.collectionView(mainvc.categoryCollection, cellForItemAt: IndexPath(row: 0, section: 0)) as! CategoryCollectionViewCell
        
        //Prior Rotation
        let priorHeight = UIScreen.main.bounds.height * 0.35
        XCTAssertEqual(cellPrior.frame.height, priorHeight)
        
        //WHEN (rotation)
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let rotateExpectation = expectation(description: "UI Refresh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            rotateExpectation.fulfill()
        }
        wait(for: [rotateExpectation], timeout: 4)
        
        
        //THEN
        let cellAfter = mainvc.collectionView(mainvc.categoryCollection, cellForItemAt: IndexPath(row: 0, section: 0)) as! CategoryCollectionViewCell
        let afterHeight = UIScreen.main.bounds.height * 0.35
        XCTAssertEqual(cellAfter.frame.height, afterHeight)
        
        // Proving height diference
        XCTAssertTrue(afterHeight<priorHeight)
    }
    
    func testLandingModel() {
        //GIVEN
        
        //Injection of mocked session
        mainvc.model.mlServices = MLServices(session: getMockedSession(), testing: true)
        
        //Mock of fetchCatalogs
        let apiEndpointCat = URL(string: "https://api.mercadolibre.com/sites/MCO/categories")!
        let expectedResponse = [
            MLServices.MLCategoryDetails(id: "1", name: "testCategory_1", picture: "123.jpg")
        ]
        var mockedData = try! JSONEncoder().encode(expectedResponse)
        let mockCat = Mock(url: apiEndpointCat, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mockCat.register()
        
        //Mock of fectCatalogDetails
        let apiEndpointDet = URL(string: "https://api.mercadolibre.com/categories/1")!
        let expectedResponseDet = MLServices.MLCategoryDetails(id: "1", name: "testCategory_1", picture: "123.jpg")
        
        mockedData = try! JSONEncoder().encode(expectedResponseDet)
        let mockDet = Mock(url: apiEndpointDet, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mockDet.register()
        
        //WHEN
        mainvc.model.delegate = mainvc
        mainvc.model.getCategories()
        let requestExpect = expectation(description: "request")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           requestExpect.fulfill()
        }
        wait(for: [requestExpect], timeout: 7)
        
        //THEN
        XCTAssertEqual(mainvc.model.catList.count, 1)
        XCTAssertEqual(mainvc.model.catList.first?.name, "testCategory_1")
        
    }
    
    func getMockedSession() -> Session{
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }
    

}
