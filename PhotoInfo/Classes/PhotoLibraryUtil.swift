//
//  PHPhotoLibraryUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/23/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Photos
import Foundation
import ReactiveCocoa

extension PHPhotoLibrary {
  
  @nonobjc static let AuthorizedKey = "authrized"
  
  static func requestAuthorization() {
    PHPhotoLibrary.requestAuthorization { (status) in
      guard status == .Authorized else {
        self.requestPermissionAlert()
        return
      }
      
      let defaultCenter = NSNotificationCenter.defaultCenter()
      defaultCenter.postNotificationName(PHPhotoLibrary.AuthorizedKey, object: self)
    }
  }
  
  static func deleteLocation(asset:PHAsset) {
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
      let changeableAsset = PHAssetChangeRequest(forAsset: asset)
      changeableAsset.location = nil
    }, completionHandler: nil)
  }
  
  static func changeLocation(asset:PHAsset, location:CLLocation) -> SignalProducer<Void ,NoError> {        return SignalProducer {
    observer, _ in
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        let changeableAsset = PHAssetChangeRequest(forAsset: asset)
        changeableAsset.location = location
      },
      completionHandler: { _ in
        observer.sendNext()
      })
    }
  }
  
  private static func requestPermissionAlert() {
    
    let alert = UIAlertController(title: "Error".toGrobal(),
                                message: "The permission of photos is denied. Please change it via setting app".toGrobal(),
                                preferredStyle: .Alert)
    
    let toSettingAction = UIAlertAction(title: "To Setting".toGrobal(), style: .Default) { _ in
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    alert.addAction(toSettingAction)
    let rootViewController = UIApplication.sharedApplication().windows.first?.rootViewController
    rootViewController?.presentViewController(alert, animated: true, completion: nil)
  }
}