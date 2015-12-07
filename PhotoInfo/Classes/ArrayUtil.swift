//
//  ArrayUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/20/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import MapKit

extension Array where Element : OnlyCustomAnnotations {
  
  func getMaxDistance() -> Double {
    let locations = self.map { $0 as! MKAnnotation }
                        .map{ CLLocation($0.coordinate) }
    
    var distances = [CLLocationDistance]()
    for var i = 0; i < locations.count - 1; i++ {
      for var j = i + 1; j < locations.count; j++ {
        let distance = locations[i].distanceFromLocation(locations[j])
        distances.append(distance)
      }
    }
    distances.sortInPlace { $0 > $1 }
    return distances.first!
  }
  
  func find(photo:Photo) -> (index:Int, annotation:CustomAnnotation) {
    let annotations = self.map{ $0 as! CustomAnnotation }
    let annotation = annotations.filter { $0.photo == photo }.first!
    let index = annotations.indexOf(annotation)!
    return (index, annotation)
  }
}

func == (left: Photo, right: Photo) -> Bool {
  return left.asset == right.asset
}
