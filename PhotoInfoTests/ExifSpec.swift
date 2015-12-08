//
//  ExifSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/11/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

@testable import photoinfo
import Quick
import Nimble

class ExifSpec: QuickSpec {
  
  override func setUp() {
    continueAfterFailure = false
  }
  
  override func spec() {
    
    
    
    describe("ImageExif") {
      
      context("General Section") {
        
        let exif = ExifParser(["Pixel": NSNumber(integerLiteral:100)])
        
        it("should be general section") {
          expect(exif.categories).notTo(beEmpty())
          expect(exif.categories.count).to(beGreaterThanOrEqualTo(0))
          expect(exif.categories[0]).notTo(beAKindOf(String))
          expect(exif.categories[0].name).to(match("GENERAL"))
        }
        
        it("content should key and value") {
          expect(exif.categories[0].contents).notTo(beEmpty())
          expect(exif.categories[0].contents.count).to(beGreaterThanOrEqualTo(0))
          expect(exif.categories[0].contents[0].key).to(match("Pixel"))
          expect(exif.categories[0].contents[0].value).to(match("100"))
        }
      }
      
      context("General Section") {
        
        let exif = ExifParser(["{IPTC}": NSDictionary(dictionary: ["Byline" : "Nico"])])
        
        it("should be general section") {
          expect(exif.categories).notTo(beEmpty())
          expect(exif.categories.count).to(beGreaterThanOrEqualTo(0))
          expect(exif.categories[0]).notTo(beAKindOf(String))
          expect(exif.categories[0].name).to(match("IPTC"))
        }
        
        it("content should key and value") {
          expect(exif.categories[0].contents).notTo(beEmpty())
          expect(exif.categories[0].contents.count).to(beGreaterThanOrEqualTo(0))
          expect(exif.categories[0].contents[0].key).to(match("Byline"))
          expect(exif.categories[0].contents[0].value).to(match("Nico"))
        }
      }
    }
  }
}

