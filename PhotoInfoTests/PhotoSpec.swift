//
//  PhotoSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/9/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

@testable import photoinfo
import Quick
import Nimble
import Photos
import ReactiveCocoa

class PhotoSpec: QuickSpec {
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    override func spec() {
        
        var photo:Photo!
        
        describe("Photo") {
            
            describe("Location") {
                
                context("is Nil") {
                    beforeEach {
                        class LocationNilMock : PHAsset {
                            override var location: CLLocation? {
                                return nil
                            }
                        }
                        photo = Photo(LocationNilMock())
                    }
                    
                    it ("should be Nil") {
                        expect(photo.location).to(beNil())
                    }
                    
                    it ("should have location error") {
                        photo.place.startWithFailed {
                            let code = LoadAssetError.Location.toError().code
                            expect($0.code).to(equal(code))
                        }
                    }
                }
            }
            
            describe("creationDate is Nil") {
                var photo:Photo!
                beforeEach {
                    class DateNilMock : PHAsset {
                        override var creationDate: NSDate? {
                            return nil
                        }
                    }
                    photo = Photo(DateNilMock())
                }
                
                it ("should be equal timeIntervalSince1970: 0") {
                    expect(photo.createdDate.timeIntervalSince1970)
                        .to(equal(NSDate(timeIntervalSince1970: 0).timeIntervalSince1970))
                }
                
            }
            
            describe("Image") {
                
                context("is empty asset") {
                    var photo:Photo!
                    beforeEach {
                        let assetMock = PHAsset()
                        photo = Photo(assetMock)
                    }
                    
                    it ("should not be nil") {
                        photo.image.startWithFailed {
                            let code = LoadAssetError.Image.toError().code
                            expect($0.code).to(equal(code))
                        }
                    }
                }
                
                context("fetch first asset") {
                    var photo:Photo!
                    beforeEach {
                        let assetMock = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
                                               .firstObject as! PHAsset
                        photo = Photo(assetMock)
                    }
                    
                    it ("should not be nil") {
                        photo.image.startWithNext {
                            expect($0).notTo(beNil())
                        }
                    }
                }
            }
            
            describe("place") {
                
                let photos = PhotoLoader().photos
                
                context("geo tag is included") {
                    
                    it("should not be empty") {
                        let expectation = self.expectationWithDescription("place fetch method")
                        
                        let locatedPhoto = photos.filter { $0.hasLocation }.first!
                        locatedPhoto.place.startWithNext {
                            expect($0.address).notTo(beEmpty())
                            expect($0.postalCode).notTo(beEmpty())
                            expectation.fulfill()
                        }
                        
                        self.waitForExpectationsWithTimeout(10) {
                            if let error = $0 {
                                XCTFail(error.description)
                            }
                        }
                    }
                }
                
                context("geo tag is not included") {
                    
                    it("should be faild with having error") {
                        let expectation = self.expectationWithDescription("place fetch method")
                        
                        let notLocatedPhoto = photos.filter { !$0.hasLocation }.first!
                        notLocatedPhoto.place.startWithFailed {
                            expect($0).to(beAKindOf(NSError))
                            expectation.fulfill()
                        }
                        
                        self.waitForExpectationsWithTimeout(1.0, handler: {
                            if let error = $0 {
                                XCTFail(error.description)
                            }
                        })
                    }
                }
            }
            
            describe("Property") {
                
                context("proper asset") {
                    
                    it("should not be empty") {
                        let photo = PhotoLoader().photos.first!
                        let expectation = self.expectationWithDescription("property fetch method")
                        
                        photo.property.startWithNext {
                            expect($0).notTo(beEmpty())
                            expectation.fulfill()
                        }
                        
                        self.waitForExpectationsWithTimeout(1.0, handler: {
                            if let error = $0 {
                                XCTFail(error.description)
                            }
                        })
                    }
                }
            }
            
            describe("Geo tag") {
                
                let photos = PhotoLoader().photos
                
                context("is nil having error") {
                    
                    let locatedPhoto = photos.filter { !$0.hasLocation }.first!
                    
                    locatedPhoto.requestAnnotation().startWithFailed {
                        expect($0).to(beAKindOf(NSError))
                    }
                }
                
                context("is not nil") {
                    
                    let notLocatedPhoto:Photo = photos.filter { $0.hasLocation }.last!
                    
                    let expectation = self.expectationWithDescription("requestAnnotation Method")
                    
                    notLocatedPhoto.requestAnnotation().startWithNext{
                        expect($0.image).notTo(beNil())
                        expect($0.subtitle).notTo(beNil())
                        expect($0.title).notTo(beNil())
                        expect($0.coordinate).notTo(beNil())
                        expectation.fulfill()
                    }
                    
                    self.waitForExpectationsWithTimeout(1.0, handler: {
                        if let error = $0 {
                            XCTFail(error.description)
                        }
                    })
                }
            }

        }
    }
}
