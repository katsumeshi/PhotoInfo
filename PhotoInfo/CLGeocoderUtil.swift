//
//  CLGeocoderUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 12/3/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Photos
import MapKit
import ReactiveCocoa

extension CLGeocoder {
  
  static func getPlace(annotation: MKAnnotation) -> SignalProducer<Place ,NSError> {
    return SignalProducer {
      observer, _ in
      
      CLGeocoder().reverseGeocodeLocation(CLLocation(annotation.coordinate),
        completionHandler: { (placemarks, error) -> Void in
          observer.sendNext(Place(placemarks!.first!))
      })
      
    }
  }
}