//
//  Review.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 12/20/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Foundation
import UIKit

class Review {
  
  static let reviewUrl = NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=998243965&mt=8&type=Purple+Software")!
  
  private static let showCount = 5
  private static let reviewKey = "reviewed"
  
  private static var visitCount:Int {
    get {
      let count = NSUserDefaults.standardUserDefaults().valueForKey(Review.reviewKey)
      if count != nil {
        return (count as! NSNumber).integerValue
      } else {
        return 1
      }
    }
  }
  
  static func showAfterInterval() {
    if Review.visitCount >= 0 {
      if (Review.visitCount % Review.showCount) == 0 {
        Review.show()
      }
      
      NSUserDefaults.standardUserDefaults().setValue(NSNumber(integer:Review.visitCount + 1), forKey: Review.reviewKey)
    }
  }
  
  private static func show() {
    
    let optionMenu = UIAlertController(title: "Review the app, please".toGrobal(), message: "Thank you for using the app:) Review tha app for updating the next feature".toGrobal(), preferredStyle: .Alert)
    
    let reviewAction = UIAlertAction(title: "Review due to satisfied".toGrobal(), style: .Default)
    { _ in
      NSUserDefaults.standardUserDefaults().setValue(NSNumber(integer: -1), forKey:  Review.reviewKey)
      UIApplication.sharedApplication().openURL(Review.reviewUrl)
    }
    let noAction = UIAlertAction(title: "Don't review due to unsatisfied".toGrobal(), style: .Default)
    { _ in
        NSUserDefaults.standardUserDefaults().setValue(NSNumber(integer: -1), forKey:  Review.reviewKey)
    }
    let laterAction = UIAlertAction(title: "Review later".toGrobal(), style: .Default, handler: nil)
    
    optionMenu.addAction(reviewAction)
    optionMenu.addAction(noAction)
    optionMenu.addAction(laterAction)
    
    let rootViewController = UIApplication.sharedApplication().windows.first?.rootViewController
    rootViewController!.presentViewController(optionMenu, animated: true, completion: nil)
  }
}
