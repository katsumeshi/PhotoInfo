//
//  AnnotationView.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 7/16/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//


import MapKit
import Photos

protocol OnlyCustomAnnotations {}
extension CustomAnnotation: OnlyCustomAnnotations{}

class CustomAnnotation: NSObject, MKAnnotation {
  
  var title: String?
  var subtitle: String?   
  let image: UIImage
  let photo:Photo
  
  var coordinate:CLLocationCoordinate2D {
    return self.photo.location!.coordinate
  }
  
  init(_ title:String, subtitle:String, image:UIImage , photo:Photo) {
    self.title = title
    self.subtitle = subtitle
    self.image = image
    self.photo = photo
  }
  
}

extension MKMapView {
  
  func centerOnMap(annotation:CustomAnnotation) {
    let coordinate = annotation.coordinate
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
    self.setRegion(coordinateRegion, animated: true)
    self.selectAnnotation(annotation, animated: true)
  }
}