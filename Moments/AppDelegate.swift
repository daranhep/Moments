//
//  AppDelegate.swift
//  Moments
//
//  Created by Dara Nhep on 5/4/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        let dummyUser = User(uid: "123",
                             username: "myUserNameDummy",
                             fullName: "My Dummy User",
                             bio: "My Dummy User",
                             website: "My Dummy User",
                             follows: [],
                             followedBy: [],
                             profileImage: UIImage(named: "1"))
        
        dummyUser.save { (error) in
            print(error)
        }
            
        
        
        return true
        
    }
}

