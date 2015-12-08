//
//  ArrayUtil.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/20/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//
import UIKit
import MapKit
import Quick
import Nimble
@testable import photoinfo

class ArrayUtilSpec: QuickSpec {
  
  override func setUp() {
    continueAfterFailure = false
  }
  
  override func spec() {
    
    describe("ArrayUtil") {
      
      let photos = PhotoLoader().photos
      let mockAnnotations = self.createMockAnnotations(photos)
      
      describe("getMaxDistance") {
        let comparebleAnnotations = [mockAnnotations.first!, mockAnnotations.last!]
        
        let maxDistance = mockAnnotations.getMaxDistance()
        let comparebleDistance = comparebleAnnotations.getMaxDistance()
        it("should be close") {
          expect(maxDistance).to(beCloseTo(comparebleDistance))
        }
      }
      
      describe("check == of photo") {
        it("should be true") {
          expect(photos.first! == photos.first!).to(beTrue())
        }
      }
      
      describe("find") {
        it("should be existed") {
          let locatedPhoto = photos.filter{ $0.hasLocation }.first!
          let (index, annotation) = mockAnnotations.find(locatedPhoto)
          expect(index).to(beGreaterThanOrEqualTo(0))
          expect(annotation.photo == locatedPhoto).to(beTrue())
        }
      }
    }
  }
  
  func createMockAnnotations(photos:[Photo]) -> [CustomAnnotation] {
    var mockAnnotations = [CustomAnnotation]()
    let locatedPhoto = photos.filter { $0.hasLocation }.first!
    
    for _ in 1...5 {
      let annotation = CustomAnnotation("", subtitle: "", image: UIImage()
        , photo: locatedPhoto)
      mockAnnotations.append(annotation)
    }
    return mockAnnotations
  }
}

