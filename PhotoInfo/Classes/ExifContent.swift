//
//  ExifContent.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/12/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit

class ExifContent {
  private(set) var key = String.empty
  private(set) var value = String.empty
  
  init(_ key:String, value:String) {
    (self.key, self.value) = ExifUtil.interpret(key, value: value)
  }
  
  convenience init(_ key:String, value:AnyObject) {
    self.init(key, value:ExifContent.toString(value))
  }
  
  private static func toString(value:AnyObject) -> String {
    
    switch(value) {
    case let string as String:
      return string
      
    case let number as NSNumber:
      return number.stringValue
      
    case let array as NSArray:
      let str = array.reduce("") { $0 + "\($1)," }
      return str.substringToIndex(str.endIndex.advancedBy(-1))
      
    default: return String.empty
    }
    
  }
  
}
