//
//  AppDelegate.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //color settings
        window?.backgroundColor = UIColor.appColor()
        UINavigationBar.appearance().barTintColor = UIColor.appColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]//!!
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UISearchBar.appearance().barTintColor = UIColor.appColor()
        UISearchBar.appearance().tintColor = UIColor.appColor()// previous application had white

        
        // Initialize Parse.
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("mmcrSN69TR6IR6e6uo2pzlhpR2amZNkHl4b0GVh1",
            clientKey: "Rmje4FSVrkEMYIdnLDdZmFpZjqlYueJzr6B4Afm7")
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        //change root controller
//
//        if let name = defaults.stringForKey("Name")
//        {
        //let defaults = NSUserDefaults.standardUserDefaults()
//            let password = defaults.stringForKey("Password")
//            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            var exampleViewController: UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Second") as! UINavigationController
//            
//            self.window?.rootViewController = exampleViewController
//            
//            self.window?.makeKeyAndVisible()
//            PFUser.logInWithUsernameInBackground(name, password: password!) {
//                (user: PFUser?, error: NSError?) -> Void in
//                if user != nil {
//                    let mycart = Cart.sharedCart()
//                    mycart.user = user
//                    //change first screen
//                    // Do stuff after successful login.
//                } else {
        
                    
//                    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    var exampleViewController: UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("FirstScreen") as! UINavigationController
//                    
//                    self.window?.rootViewController = exampleViewController
//                    
//                    self.window?.makeKeyAndVisible()
//                    var alert = UIAlertView(title: nil, message: "Вы не зашли в аккаунт!", delegate: self, cancelButtonTitle: "ок")
//                    alert.show()
                    
                    
                    
                    
                    // The login failed. Check error to see why.
//                }
//            }
        
            

            
//        }
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            let mycart = Cart.sharedCart()
            mycart.internet = false
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Отсутсвует соединение с интернетом", message: "Пожалуйста установите соединение с интернетом", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        Helpshift.installForApiKey("943b0296194a2fdfba961ff77018ef7b",
            domainName: "expfood.helpshift.com",
            appID: "expfood_platform_20150925123405193-f7d67e0eb155fb7")

        // Override point for customization after application launch.
        return true
    }
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}

