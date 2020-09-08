//
//  LandingTests.swift
//  MirandaMallTests
//
//  Created by Jorge Miranda on 7/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import XCTest
@testable import MirandaMall


class LandingTests: XCTestCase {

    var mainvc: LandingViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LandingViewController = storyboard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
        mainvc = vc
        mainvc.model.mlServices.sessionManager = nil
        _ = mainvc.view // To call viewDidLoad
    }
    
    override func tearDown() {
        mainvc = nil

        
        super.tearDown()
    }
    
    func testColeccionCells(){
        mainvc.model.catList = [
            MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png"),
            MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png"),
            MLServices.MLCategoryDetails(id: "MLA5725", name: "Accesorios para Vehículos", picture: "http://resources.mlstatic.com/category/images/6fc20d84-2ce6-44ee-8e7e-e5479a78eab0.png")]
        DispatchQueue.main.async {
            self.mainvc.categoryCollection.reloadData()
        }
        let requestExpectation = expectation(description: "UI Refresh")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            requestExpectation.fulfill()
        }
        
        wait(for: [requestExpectation], timeout: 15)
        
        let cell = mainvc.collectionView(mainvc.categoryCollection, cellForItemAt: IndexPath(row: 0, section: 0)) as! CategoryCollectionViewCell
        
        XCTAssertEqual(mainvc.categoryCollection.numberOfItems(inSection: 0), 3)
        XCTAssertEqual(cell.mainLabel.text, mainvc.model.catList[0].name)
        
    }
    
    

}
