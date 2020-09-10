//
//  ItemListTests.swift
//  MirandaMallTests
//
//  Created by Jorge Miranda on 9/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import XCTest
@testable import MirandaMall

class ItemListTests: XCTestCase {

    var mainvc: ItemListViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ItemListViewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
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
    
    func testAppearence(){
        //GIVEN
        mainvc.query = "TestQuery"
        mainvc.categoryInfo = MLServices.MLCategoryDetails()
        
        //WHEN
        mainvc.viewDidLoad()
        
        //THEN
        XCTAssertEqual(mainvc.searchBar.placeholder, "Que quieres vitrinear?")
        XCTAssertEqual(mainvc.searchBar.text, "TestQuery")
    }
    
    func testItemListCellContent() {
        //GIVEN
        let data = [
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: ""),
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: ""),
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: "")
        ]
        mainvc.model.itemList = data
        
        //WHEN
        
        mainvc.setItems()
        let cell = mainvc.tableView(mainvc.itemListTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ItemListTableViewCell
        //THEN
        XCTAssertEqual(mainvc.itemListTableView.numberOfRows(inSection: 0), 3)
        XCTAssertEqual(cell.itemInfo , data[0])
    }
    
    func testItemListIsCatalog() {
        //GIVEN
        mainvc.query = ""
        mainvc.categoryInfo = MLServices.MLCategoryDetails(id: "ABC", name: "TESTCATEGORY", picture: nil)
        
        let data = [
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: "")
        ]
        mainvc.model.itemList = data
        
        //WHEN
        mainvc.setItems()
        
        //THEN
        XCTAssertEqual(mainvc.tableView(mainvc.itemListTableView, titleForHeaderInSection: 0), "TESTCATEGORY")
    }
    
    func testErrorNoResults(){
        //GIVEN
        
        //WHEN
        mainvc.noResults()
        
        //THEN
        let errorTitle = mainvc.errorView.subviews.filter({ $0.isKind(of: UILabel.self)}).first as! UILabel
        let errorImage = mainvc.errorView.subviews.filter({ $0.isKind(of: UIImageView.self)}).first as! UIImageView
        let testImage: UIImage = #imageLiteral(resourceName: "notFoundIcon")
        XCTAssertEqual(errorTitle.text, "No se encontraron resultados :(")
        XCTAssertEqual(errorImage.image, testImage)
    }
    
    func testErrorInRequest(){
        //GIVEN
        
        //WHEN
        mainvc.errorInRequest()
        
        //THEN
        let errorTitle = mainvc.errorView.subviews.filter({ $0.isKind(of: UILabel.self)}).first as! UILabel
        let errorImage = mainvc.errorView.subviews.filter({ $0.isKind(of: UIImageView.self)}).first as! UIImageView
        let testImage: UIImage = #imageLiteral(resourceName: "errorIcon")
        XCTAssertEqual(errorTitle.text, "Hubo un error inesperado. \n Intenta de nuevo :)")
        XCTAssertEqual(errorImage.image, testImage)
    }
    
    func testLoaderCell(){
        //GIVEN
        let data = [
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: ""),
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: ""),
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: "")
        ]
        mainvc.model.itemList = data
        mainvc.loadMoreItems = true
        //WHEN
        mainvc.setItems()
        
        //THEN
        
        XCTAssertEqual(mainvc.itemListTableView.numberOfRows(inSection: 0), 3) // Items section
        XCTAssertEqual(mainvc.itemListTableView.numberOfRows(inSection: 1), 1) // Loader section
        
        let loaderCell = mainvc.tableView(mainvc.itemListTableView, cellForRowAt: IndexPath(row: 0, section: 1)) as! LoadingTableViewCell
        
        XCTAssertTrue(loaderCell.loader.isAnimating)
    }
    
    func testScrollEnd(){
        
        //GIVEN
        let data = [
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: ""),
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: ""),
            MLServices.MLSearchResult(id: "abc", title: "Test1", price: 200, category_id: "ABC123", thumbnail: "")
        ]
        mainvc.model.itemList = data
        mainvc.loadMoreItems = true
        
        //WHEN
        mainvc.scrollViewDidScroll(mainvc.itemListTableView)
        
        //THEN
        XCTAssertTrue(mainvc.isLoading)
        
    }
    
    func testSearchButton(){
        //GIVEN
        mainvc.searchBar.text = "TestQuery"
        
        //WHEN
        mainvc.searchBar.searchTextField.becomeFirstResponder()
        mainvc.searchBarSearchButtonClicked(mainvc.searchBar)
        
        //THEN
        XCTAssertEqual(mainvc.query, "TestQuery")
    }

}
