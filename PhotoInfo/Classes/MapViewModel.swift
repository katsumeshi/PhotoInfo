//
//  MapViewModel.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/16/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import ReactiveCocoa
import Foundation
import Photos

class MapViewModel {
  
  var annotations = MutableProperty<[CustomAnnotation]>([CustomAnnotation]())
  private(set) var selectingPhoto:Photo?
  
  init(_ photos:[Photo]) {
    reload(photos)
  }
  
  func reload(photos:[Photo]) {
    requestAnnotations(photos).startWithNext {
      self.annotations.value = $0
    }
  }
  
  func select(photo:Photo) {
    selectingPhoto = photo
  }
  
  func new(photo:Photo, coordinate:CLLocationCoordinate2D) -> SignalProducer<Void ,NoError> {
    return PHPhotoLibrary.changeLocation(photo.asset, location: CLLocation(coordinate))
  }
  
  func update(coordinate:CLLocationCoordinate2D) -> SignalProducer<Void ,NoError> {
    return PHPhotoLibrary.changeLocation(selectingPhoto!.asset, location: CLLocation(coordinate))
  }
  
  func delete() {
    let index = annotations.value.find(selectingPhoto!).index
    annotations.value.removeAtIndex(index)
    PHPhotoLibrary.deleteLocation(selectingPhoto!.asset)
  }
  
  func getCenterRegionOnMap() -> MKCoordinateRegion? {
    let annotations = self.annotations.value
    guard annotations.count > 1 else {
      return nil
    }
    
    let maxDistantce = annotations.getMaxDistance()
    let coordinate = annotations.last!.coordinate
    return MKCoordinateRegionMakeWithDistance(coordinate,  maxDistantce,  maxDistantce)
  }
  
}

extension MapViewModel {
  
  private func requestAnnotations(photos:[Photo]) -> SignalProducer<[CustomAnnotation] ,NSError> {
    return SignalProducer {
      observer, _ in
      var annotations = [CustomAnnotation]()
      let locatedPhotoCount = photos.filter{ $0.hasLocation }.count
      photos.forEach {
        $0.requestAnnotation().startWithNext {
          annotations.append($0)
          if locatedPhotoCount == annotations.count {
            observer.sendNext(annotations)
          }
        }
      }
    }
  }
  
}


