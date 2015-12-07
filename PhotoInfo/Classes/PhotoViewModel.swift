//
//  PhotoViewModel.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 10/31/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import ReactiveCocoa

class PhotoListViewModel {
  
  private(set) var photos = MutableProperty<[Photo]>([Photo]())
  lazy private var sortOrder:() -> () = { self.sortGeo() }
  
  init(_ photos:[Photo]) {
    reload(photos)
  }
  
  func sortGeo() {
    self.photos.value.sortInPlace {
      return $1.location == nil
    }
    sortOrder = sortGeo
  }
  
  func sortDate() {
    self.photos.value.sortInPlace {
      return $0.createdDate.timeIntervalSince1970 > $1.createdDate.timeIntervalSince1970
    }
    sortOrder = sortDate
  }
  
  func reload(photos:[Photo]) {
    self.photos.value = photos
    sortOrder()
  }
}