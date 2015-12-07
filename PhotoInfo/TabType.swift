//
//  UITabBarControllerUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/30/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Foundation
import UIKit


enum TabType : Int {
  case List = 0
  case Map
  case Setting
  
  
  var title:String {
    switch self{
    case .List:
      return "List"
    case .Map:
      return "Map"
    case .Setting:
      return "Setting"
    }
  }
  
  var image:UIImage {
    let color = UIColor.whiteColor()
    let size = CGSizeMake(30, 30)
    switch self{
    case .List:
      return UIImage.fontAwesomeIconWithName(.List,
                                              textColor: color,
                                              size: size)
    case .Map:
      return UIImage.fontAwesomeIconWithName(.Globe,
                                              textColor: color,
                                              size: size)
    case .Setting:
      return UIImage.fontAwesomeIconWithName(.Gears,
                                              textColor: color,
                                              size: size)
    }
  }
  
  var item:UITabBarItem {
    return UITabBarItem(title: self.title, image: self.image, tag: self.rawValue)
  }
}