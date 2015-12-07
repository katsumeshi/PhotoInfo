//
//  Photo.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/9/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import ReactiveCocoa
import Photos

class Photo {
  
  private(set) var createdDate = NSDate(timeIntervalSince1970: 0)
  private(set) var location:CLLocation?
  private(set) var asset:PHAsset
  
  init(_ asset:PHAsset) {
    if let createdDate = asset.creationDate {
      self.createdDate = createdDate
    }
    location = asset.location
    self.asset = asset
  }
  
  var hasLocation:Bool {
    return self.location != nil
  }
  
  var image:SignalProducer<UIImage, NSError> {
    return SignalProducer {
      observer, _ in
      PHImageManager.defaultManager().requestImageForAsset(self.asset,
        targetSize: CGSize(width: 100.0, height: 100.0),
        contentMode: .AspectFill,
        options: nil)
        { (result, _) in
          guard let image = result else {
            observer.sendFailed(LoadAssetError.Image.toError())
            return
          }
          observer.sendNext(image)
      }
    }
  }
  
  var place:SignalProducer<Place, NSError>  {
    return SignalProducer {
      observer, _ in
      
      guard let location = self.location else {
        observer.sendFailed(LoadAssetError.Location.toError())
        return
      }
      
      CLGeocoder().reverseGeocodeLocation(location)
        { (placemarks, error) in
          
          if placemarks == nil || error != nil {
            observer.sendFailed(LoadAssetError.Placemark.toError())
            return
          }
          
          observer.sendNext(Place(placemarks?.first))
      }
    }
  }
  
  var property:SignalProducer<[String:AnyObject], NSError>  {
    
    return SignalProducer {
      observer, _ in
      let options = PHContentEditingInputRequestOptions()
      self.asset.requestContentEditingInputWithOptions(options)
        { (editingInput, _) in
        
        guard let input = editingInput else {
          observer.sendFailed(LoadAssetError.Property.toError())
          return
        }
        
        guard let url = input.fullSizeImageURL else {
          observer.sendFailed(LoadAssetError.Property.toError())
          return
        }
        
        guard var ciImage = CIImage(contentsOfURL: url) else {
          observer.sendFailed(LoadAssetError.Property.toError())
          return
        }
        
        let orientation = input.fullSizeImageOrientation
        ciImage = ciImage.imageByApplyingOrientation(orientation)
        observer.sendNext(ciImage.properties)
      }
    }
  }
  
  func requestAnnotation() -> SignalProducer<CustomAnnotation ,NSError> {
    return SignalProducer {
      observer, _ in
      
      let comb = combineLatest(self.image, self.place)
      comb.on(failed: {
        observer.sendFailed($0)
        }, next:{
          let annotation =  CustomAnnotation($1.postalCode,
            subtitle:$1.address,
            image:$0,
            photo: self)
          observer.sendNext(annotation)
      }).start()
    }
  }
}

enum LoadAssetError: Int {
  case Location = 0
  case Image
  case Placemark
  case Property
  case Reverse
  
  func toError() -> NSError {
    switch(self) {
    case .Location:
      return NSError(domain:"LoadAsset", code: self.rawValue, userInfo: nil)
    case .Image:
      return NSError(domain:"Image", code: self.rawValue, userInfo: nil)
    case .Placemark:
      return NSError(domain:"Placemark", code: self.rawValue, userInfo: nil)
    case .Property:
      return NSError(domain:"Property", code: self.rawValue, userInfo: nil)
    case .Reverse:
      return NSError(domain:"Reverse", code: self.rawValue, userInfo: nil)
    }
  }
}
