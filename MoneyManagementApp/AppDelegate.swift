//
//  AppDelegate.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 07/07/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let firstVC = FirstViewController()
        
        window?.rootViewController = firstVC
        window?.makeKeyAndVisible()
        return true
    }

}

// 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
