//
//  AppDelegate.swift
//  本番
//
//  Created by 米田大弥 on 2018/06/23.
//  Copyright © 2018年 hiroya. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundDate = Date()
    var foregroundDate = Date()
    var message:Double! = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        //通知していいかの確認
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler:{ (success, error) in
            if error == nil {
//                print("success!")
            }
        })
        
        UIApplication.shared.isIdleTimerDisabled = true//スリープ状態にならない
    
        return true

    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    //教室から出た時
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    let backgroundDate = Int(Date().timeIntervalSince1970)
   

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidEnterBackground"), object: nil)
    
            backgroundDate = Date()
//            print(backgroundDate)
    
    }
    
    func getIntervalDays(BeforeDate:Date?,AfterDate:Date? = nil) -> Double {
        
        var retInterval:Double!
        
        if AfterDate == nil {
            retInterval = BeforeDate?.timeIntervalSinceNow
        } else {
            retInterval = BeforeDate?.timeIntervalSince(AfterDate!)
        }
        
        let ret = retInterval
        
        return ceil(ret!)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)
        
        foregroundDate = Date()
//        print(foregroundDate)
    
      message = (getIntervalDays(BeforeDate: backgroundDate, AfterDate: foregroundDate))
        
    }
        
//    //[iOS8以降]Push通知の実装とテスト(swift)を参考
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        switch application.applicationState {
//        case .active:
//            break
//        case .inactive:
//            break
//        case .background:
//            break
//        }
//    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
        
    }

    



