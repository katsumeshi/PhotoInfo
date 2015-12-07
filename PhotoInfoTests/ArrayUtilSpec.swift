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
            let mockAnnotations = self.createMockAnnotations()
            let comparebleAnnotations = [mockAnnotations.first!, mockAnnotations.last!]
            
            let maxDistance = mockAnnotations.getMaxDistance()
            let comparebleDistance = comparebleAnnotations.getMaxDistance()
            it("should be close") {
                expect(maxDistance).to(beCloseTo(comparebleDistance))
            }
        }
    }
    
    func createMockAnnotations() -> [CustomAnnotation] {
        var mockAnnotations = [CustomAnnotation]()
        let photos = PhotoLoader().photos
        let locatedPhoto = photos.filter { $0.hasLocation }.first!
        
        for _ in 1...5 {
            let annotation = CustomAnnotation("", subtitle: "", image: UIImage()
                                                , photo: locatedPhoto)
            mockAnnotations.append(annotation)
        }
        return mockAnnotations
    }
}

