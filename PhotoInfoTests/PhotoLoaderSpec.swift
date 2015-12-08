//
//  PhotoLoaderSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/9/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

@testable import photoinfo
import Quick
import Nimble

class PhotoLoaderSpec: QuickSpec {
  
  override func setUp() {
    continueAfterFailure = false
  }
  
  override func spec() {
    let photoLoader = PhotoLoader()
    describe("PhotoLoader") {
      describe("init") {
        it ("should be grater than zero") {
          expect(photoLoader.photos.count).to(beGreaterThanOrEqualTo(0))
        }
      }
    }
  }
}
