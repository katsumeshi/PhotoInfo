//
//  AppReviewSpec.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/10/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

@testable import photoinfo
import Quick
import Nimble

class AppReviewSpec: QuickSpec {
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    override func spec() {
        
        beforeSuite {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("reviewed")
        }
        
        afterSuite {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("reviewed")
        }
        
        describe("showAppReview") {
            
            context("inclement four times") {
                it("should be false") {
                    expect(AppReview.canShow()).to(beFalse())
                    expect(AppReview.canShow()).to(beFalse())
                    expect(AppReview.canShow()).to(beFalse())
                    expect(AppReview.canShow()).to(beFalse())
                }
            }
            
            context("fifth inclement") {
                it("should be true") {
                    expect(AppReview.canShow()).to(beTrue())
                }
            }
            
            context("sixth inclement") {
                it("should be false") {
                    expect(AppReview.canShow()).to(beFalse())
                }
            }
            
        }
    }
}

