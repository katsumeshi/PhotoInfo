//
//  PhotoLoader.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 10/25/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Photos

class PhotoLoader {
  
  private(set) var photos:[Photo]
  
  init() {
    var photos = [Photo]()
    let result =  PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
    result.enumerateObjectsUsingBlock { (object, idx, _) in
      if let asset = object as? PHAsset {
        photos.append(Photo(asset))
      }
    }
    self.photos = photos
  }
  
}

