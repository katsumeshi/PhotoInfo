//
//  ExifParser.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/12/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Photos

class ExifParser {
  
  private(set) var categories = [ExifCategory]()
  
  init() {}
  
  init(_ properties: [String : AnyObject]) {
    self.parseGeneral(properties)
    self.parseCategories(properties)
  }
  
  // Category of general is diffrent structure from the others
  private func parseGeneral(properties: [String : AnyObject]) {
    for (key , _) in properties {
      if !key.hasPrefix("{") {
        categories.append(ExifCategory(properties))
        return
      }
    }
  }
  
  private func parseCategories(properties: [String : AnyObject]) {
    for (key , value) in properties {
      guard key.hasPrefix("{") else {
        continue
      }
      categories.append(ExifCategory(key, value: value as! NSDictionary))
    }
  }
}
