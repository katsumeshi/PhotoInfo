//
//  Place.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/9/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import Photos

class Place {
  var address:String
  var postalCode:String
  
  init (_ placemark:CLPlacemark?){
    postalCode = placemark?.getPostalCode() ?? "N/A"
    address = placemark?.getAddress() ?? "N/A"
  }
}

extension CLPlacemark {
  
  func getPostalCode() -> String? {
    return self.postalCode ?? nil
  }
  
  func getAddress() -> String? {
    var address = String.empty
    address += getMainAreaName()
    address += getSubAreaName()
    address += getLocalAreaName()
    return address.isEmpty ? nil : address
  }
  
  private func getMainAreaName() -> String {
    return administrativeArea ?? subAdministrativeArea ?? String.empty
  }
  
  private func getSubAreaName() -> String {
    return locality ?? subLocality ?? String.empty
  }
  
  private func getLocalAreaName() -> String {
    return thoroughfare ?? subThoroughfare ?? String.empty
  }
}