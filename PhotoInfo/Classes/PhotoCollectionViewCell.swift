//
//  PhotoCollectionViewCell.swift
//  photomap
//
//  Created by Yuki Matsushita on 5/6/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class PhotoCollectionViewCell : UICollectionViewCell {
  
  func bind(photo:Photo) {
    photo.image.observeOn(UIScheduler()).startWithNext {
      let imageView = UIImageView(image: $0)
      let pinView = self.generatePinImageView()
      pinView.hidden = !photo.hasLocation
      imageView.addSubview(pinView)
      self.backgroundView = imageView
    }
  }
  
  private func generatePinImageView() -> UIImageView {
    let pinImageView = UIImageView(image: UIImage(named: "pin"))
    pinImageView.frame = getPinViewFrame()
    return pinImageView
  }
  
  
  private func getPinViewFrame() ->CGRect {
    let isIpad = (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
    let iconSize:CGFloat = isIpad ? 60 : 30
    return CGRect(x: self.frame.size.width - iconSize,
      y: self.frame.size.height - iconSize,
      width: iconSize,
      height: iconSize)
    
  }
}
