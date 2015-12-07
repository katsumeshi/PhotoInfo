//
//  ExifViewModel.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/10/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import ReactiveCocoa

class ExifViewModel {
  
  private(set) var exifParser = MutableProperty<ExifParser>(ExifParser())
  private(set) var photo: Photo
  
  init(_ photo:Photo) {
    
    self.photo = photo
    photo.property.startWithNext {
      self.exifParser.value = ExifParser($0)
    }
    
  }
}
