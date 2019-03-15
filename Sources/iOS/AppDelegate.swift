//
//  AppDelegate.swift
//  ChartsTGCiOS
//
//  Created by iMac on 15.03.2019.
//  Copyright © 2019 Nipel Systems. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let root = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.darkGray
        
        return true
    }

}

