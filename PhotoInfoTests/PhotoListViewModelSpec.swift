//
//  PhotoViewControlellerSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/5/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//


@testable import photoinfo
import Quick
import Nimble
import Photos

class PhotoListViewModelSpec: QuickSpec {
  
  override func setUp() {
    continueAfterFailure = false
  }
  
  override func spec() {
    describe("PhotoListViewModel") {
      
      describe("Photos") {
        
        class OldAsset : PHAsset {
          override var creationDate : NSDate {
            return NSDate(timeIntervalSince1970: 0)
          }
          override var location: CLLocation? {
            return nil
          }
        }
        class NewAsset : PHAsset {
          override var creationDate : NSDate {
            return NSDate(timeIntervalSince1970: 1000)
          }
          override var location: CLLocation? {
            return CLLocation(latitude: 0.2, longitude: 0.1)
          }
        }
        
        let photosMock = [Photo(OldAsset()), Photo(NewAsset())]
        let viewModel = PhotoListViewModel(photosMock)
        
        describe("init") {
          it ("should be grater than zero") {
            expect(viewModel.photos.value.count).to(beGreaterThanOrEqualTo(0))
          }
        }
        
        describe("date sort") {
          it ("should be date sort order") {
            viewModel.sortDate()
            let new = viewModel.photos.value.first!.createdDate.timeIntervalSince1970
            let old = viewModel.photos.value.last!.createdDate.timeIntervalSince1970
            expect(new).to(beGreaterThan(old))
          }
        }
        
        describe("geo sort") {
          it ("should be geo sort order") {
            viewModel.sortGeo()
            let new = viewModel.photos.value.first!.location
            let old = viewModel.photos.value.last!.location
            expect(new).notTo(beNil())
            expect(old).to(beNil())
          }
        }
      }
    }
  }
}