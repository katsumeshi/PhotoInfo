//
//  ExifCategory.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/12/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit

class ExifCategory {
  private(set) var name = String.empty
  private(set) var contents = [ExifContent]()
  
  init () {}
  
  init (_ key: String, value:NSDictionary) {
    self.name = key.stringByReplacingOccurrencesOfString("{", withString: "")
      .stringByReplacingOccurrencesOfString("}", withString: "")
    value.forEach { contents.append(ExifContent($0.description, value: $1 )) }
  }
  
  init (_ properties:[String : AnyObject]) {
    self.name = "GENERAL"
    let filteredProperties = properties.filter { $0.1 is NSNumber }
    filteredProperties.forEach { contents.append(ExifContent($0, value: $1.description)) }
  }
}