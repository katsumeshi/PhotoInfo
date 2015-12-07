//
//  UIImageUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/16/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//


import UIKit
extension UIImage {
  
  func resize(size:CGSize) -> UIImage {
    
    UIGraphicsBeginImageContext(size)
    self.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    let context = UIGraphicsGetCurrentContext()
    CGContextSetInterpolationQuality(context, .High)
    UIGraphicsEndImageContext()
    
    return resizedImage
  }
  
}
