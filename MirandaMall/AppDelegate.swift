//
//  AppDelegate.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 5/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard normalExecutionPath() else {
            window = nil
            return false
        }

        // regular setup

        return true
    }

    private func normalExecutionPath() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }

}

