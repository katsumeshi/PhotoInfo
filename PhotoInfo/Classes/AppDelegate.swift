//
//  AppDelegate.swift
//  photomap
//
//  Created by Yuki Matsushita on 5/5/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Photos
import ReactiveCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    Fabric.with([Crashlytics()])
    
    
    return true
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    PHPhotoLibrary.requestAuthorization()
  }
}

extension NSNotificationCenter {
  
  class func addObserver(key:String) -> RACSignal! {
    return NSNotificationCenter.defaultCenter()
           .rac_addObserverForName(key, object: nil)
  }
}

