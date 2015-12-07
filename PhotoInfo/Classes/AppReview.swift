//
//  Review.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 10/25/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit

class AppReview {
  
  private static let intervalShowCount = 5
  private static let reviewedKey = "reviewed"
  
  private static let userDefaults = NSUserDefaults.standardUserDefaults()
  
  private static var visitedCount:Int {
    guard let value = userDefaults.valueForKey(reviewedKey) else {
      return 0
    }
    return value as! Int
  }
  
  static func canShow() -> Bool {
    incrementVisitedCount()
    return (visitedCount % intervalShowCount) == 0
  }
  
  private static func incrementVisitedCount() {
    userDefaults.setObject(NSNumber(int: visitedCount + 1), forKey: reviewedKey)
  }
  
}