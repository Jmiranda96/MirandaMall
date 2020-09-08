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
    
    private func setUpViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        self.mainvc = (storyboard.instantiateViewControllerWithIdentifier("LandingViewController") as! LandingViewController) //
        self.mainvc.loadView()
        self.mainvc.viewDidLoad()
    }
    
    override func setUp() {
        super.setUp()

        self.setUpViewControllers()
    }
    
    override func tearDown() {
        mainvc = nil
        
        super.tearDown()
    }

}
