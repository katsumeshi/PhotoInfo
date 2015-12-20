//
//  SettingViewController.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 12/19/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import Social

enum SettingType {
  case Review
  case RemoveAdvertisement
  case Facebook
  case TwitterShare
  case FacebookShare
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  @IBOutlet weak var tableView: UITableView?
  var titles = [[SettingType.Review:"Review the app".toGrobal()],
                [SettingType.RemoveAdvertisement:"Remove advertisement".toGrobal()],
                [SettingType.Facebook:"Facebook fun site".toGrobal()],
                [SettingType.TwitterShare:"Share the app via Twitter".toGrobal()],
                [SettingType.FacebookShare:"Share the app via Facebook".toGrobal()]]
  
  let purchaseManager = PurchaseManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.reloadTitles()
    self.tableView?.contentInset.bottom = PurchaseManager.purchased ? 0 : 50
    
    purchaseManager.purchaseClouser = reloadTitles
    
    purchaseManager.restoreClosure = { () -> Void in
      self.reloadTitles()
      let alertController = UIAlertController(title:"Confirmation".toGrobal(),
        message: "Restored your bought item".toGrobal(), preferredStyle: UIAlertControllerStyle.Alert)
      
      let cancelAction = UIAlertAction(title: "Close".toGrobal(), style: UIAlertActionStyle.Default, handler:
        nil)
      
      alertController.addAction(cancelAction)
      self.presentViewController(alertController, animated: true, completion:nil)
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    
    super.viewWillDisappear(animated)
//    if !(self.navigationController!.viewControllers.contains(self)) {
//      self.tableView?.removeFromSuperview()
//    }
  }
  
  func reloadTitles() {
    if PurchaseManager.purchased {
      titles.removeAtIndex(1)
      self.tableView!.reloadData()
      
      for var i = 0; i < self.tabBarController!.viewControllers!.count; i++ {
        let naviViewController = self.tabBarController!.viewControllers![i] as! UINavigationController
        for var j = 0; j < naviViewController.viewControllers.count; j++ {
//          let viewController = naviViewController.viewControllers[j] as! UIViewController
//          viewController.view.purchasedRemoveAds()
        }
      }
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    switch (titles[indexPath.item].keys.first!) {
    case SettingType.Review:
      UIApplication.sharedApplication().openURL(Review.reviewUrl)
    case SettingType.RemoveAdvertisement:
      
      let alertController = UIAlertController(title:"Remove advertisement".toGrobal(), message: "", preferredStyle: .Alert)
      
      let purchaseAction = UIAlertAction(title: "Purchase".toGrobal(), style: .Default) { _ in
        self.purchaseManager.buy()
      }
      
      let restoreAction = UIAlertAction(title: "Restore".toGrobal(), style: .Default) { _ in
        self.purchaseManager.restore()
      }
      let cancelAction = UIAlertAction(title: "Close".toGrobal(), style: .Default, handler: nil)
      
      alertController.addAction(purchaseAction)
      alertController.addAction(restoreAction)
      alertController.addAction(cancelAction)
      
      self.presentViewController(alertController, animated: true, completion:nil)
      
    case SettingType.Facebook:
      
      let fbURL = NSURL(string: "fb://profile/472766872878196")
      let httpURL = NSURL(string: "https://www.facebook.com/photoinfoapp")
      
      if UIApplication.sharedApplication().canOpenURL(fbURL!) {
        UIApplication.sharedApplication().openURL(fbURL!)
      } else {
        UIApplication.sharedApplication().openURL(httpURL!)
      }
    case SettingType.TwitterShare:
      self.presentViewController(SLComposeViewController.getTwitterControllerWithText(), animated: true, completion: nil)
    case SettingType.FacebookShare:
      self.presentViewController(SLComposeViewController.getFacebookControllerWithText(), animated: true, completion: nil)
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("SettingTableViewCell", forIndexPath: indexPath) 
    
    cell.textLabel?.text = titles[indexPath.item].values.first
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.titles.count
  }
  
}

extension SLComposeViewController {
  
  static func getTwitterControllerWithText() -> SLComposeViewController {
    let twitterController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
    twitterController.setInitialText("the recommendation app!\n\"Photo Info! - 写真情報、撮影位置確認\"\n#PhotoInfo!\nhttps://goo.gl/9TrJNf".toGrobal())
    return twitterController
  }
  
  static func getFacebookControllerWithText() -> SLComposeViewController {
    let facebookController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
    facebookController.setInitialText("the recommendation app!\n\"Photo Info! - 写真情報、撮影位置確認\"\n#PhotoInfo!\nhttps://goo.gl/9TrJNf".toGrobal())
    return facebookController
  }
}
