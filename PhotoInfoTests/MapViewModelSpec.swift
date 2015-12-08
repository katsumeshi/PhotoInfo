//
//  MapViewModelSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/16/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//


import Quick
import Nimble
import Photos
@testable import photoinfo

class MapViewModelSpec: QuickSpec {
  
  override func setUp() {
    continueAfterFailure = false
  }
  
  override func spec() {
    
    describe("MapViewModelSpec") {
      
      let photos = PhotoLoader().photos
      let viewModel = MapViewModel(photos)
      
      describe("init") {
        
        it("should be shown custom annotations") {
          expect(viewModel.annotations.value.count).to(beGreaterThanOrEqualTo(0))
        }
        
        viewModel.annotations.producer.startWithNext {
          if $0.count == 0 { return }
          expect($0.last!.title).notTo(beEmpty())
        }
        
      }
      
      describe("the annotations") {
        
        describe("select") {
          viewModel.select(photos.first!)
          it("should be true") {
            expect(viewModel.selectingPhoto! == photos.first!).to(beTrue())
          }
        }
      }
    }
  }
}
