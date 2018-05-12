//
//  AppDelegate.swift
//  Todoey
//
//  Created by Miguel Ángel Hernández Muñoz on 4/28/18.
//  Copyright © 2018 Miguel Ángel Hernández Muñoz. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new realm \(error)")
        }
        
        return true
    }
}

