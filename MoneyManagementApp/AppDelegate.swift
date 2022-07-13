//
//  AppDelegate.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 07/07/2022.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
              // Show the app's signed-out state.
            } else {
              // Show the app's signed-in state.
            }
          }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if Auth.auth().currentUser?.uid != nil {
        self.window?.rootViewController = UINavigationController.init(rootViewController: CustomTabBarController())
        } else {
        self.window?.rootViewController = UINavigationController.init(rootViewController: LoginVC())
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
          return true
        }

        // Handle other custom URL types.

        // If not handled by this app, return false.
        return false
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
}

// 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
