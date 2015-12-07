//
//  MapViewModelSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/16/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//


import Quick
import Nimble
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
//            describe("the annotations") {
//                beforeEach {
//                    photos[0].requestAnnotation().startWithNext {
//                        viewModel.beginEdit($0)
//                    }
//                }
//                
//                describe("edit") {
//                
//                    it("edit confirm") {
//                        let editingAnnotation = viewModel.editingAnnotation
//                        expect(editingAnnotation.title).notTo(beEmpty())
//                    }
//                    
//                    it("edit end") {
//    let annotation = CustomAnnotation("new", subtitle: "new", image: UIImage(),
//                            coordinate: CLLocationCoordinate2D(1, 1))
//                        viewModel.endEdit(annotation)
//                        expect(viewModel.selectedAnnotation).to(beNil())
//                    }
//                }
//                
//                it("delete") {
//                    viewModel.delete()
//                    expect(viewModel.selectedAnnotation).to(beNil())
//                }
//            }
        }
    }
}
