//
//  tabBarController.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 7/16/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//

import FontAwesome
import ReactiveCocoa

class TabBarController: UITabBarController, UITabBarControllerDelegate {
  
  let reviewUrl = NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=998243965&mt=8&type=Purple+Software")!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpAppearance()
    didBecomeNotificationAction()
    self.delegate = self
  }
  
}


extension TabBarController {
  
  // MARK: - Private Methods
  
  private func setUpAppearance() {
    self.view.backgroundColor = UIColor.whiteColor()
    UITabBar.appearance().tintColor = UIColor.whiteColor()
    self.childViewControllers.enumerate().forEach {
      $0.element.tabBarItem = TabType(rawValue: $0.index)?.item
    }
  }
  
  private func didBecomeNotificationAction() {
    
    let didbecomeSignal = NSNotificationCenter.addObserver(UIApplicationDidBecomeActiveNotification)
    didbecomeSignal.subscribeNext { _ in
      if AppReview.canShow() {
        self.showAppReviewRequestAlert()
      }
    }
  }
  
  private func showAppReviewRequestAlert() {
    
    let alertView = UIAlertController(title: "Review the app, please".toGrobal(),
      message: "Thank you for using the app:) Review tha app for updating the next feature".toGrobal(),
      preferredStyle: .Alert)
    
    let reviewAction = UIAlertAction(title: "Review due to satisfied".toGrobal(),
      style: .Default) { _ in
        UIApplication.sharedApplication().openURL(self.reviewUrl)
    }
    
    let noAction = UIAlertAction(title: "Don't review due to unsatisfied".toGrobal(), style: .Default, handler: nil)
    let laterAction = UIAlertAction(title: "Review later".toGrobal(), style: .Default, handler: nil)
    
    alertView.addAction(reviewAction)
    alertView.addAction(noAction)
    alertView.addAction(laterAction)
    
    self.presentViewController(alertView, animated: true, completion: nil)
  }
}

