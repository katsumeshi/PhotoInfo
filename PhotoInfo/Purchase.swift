
//
//  PurchaseManager.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 7/6/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  static let PRODUCT_ID = ""
  static let PURCHASED_KEY = "purchased"
  static var purchased:Bool {
    get {
      return NSUserDefaults.standardUserDefaults().boolForKey(PurchaseManager.PURCHASED_KEY)
    }
  }
  var purchaseClouser = { () -> Void in }
  var restoreClosure = { () -> Void in }
  
  func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    
    print("productsRequest")
    if response.products.count > 0 {
      let validProduct: SKProduct = response.products[0] 
      if validProduct.productIdentifier == PurchaseManager.PRODUCT_ID {
        let payment = SKPayment(product: validProduct)
        SKPaymentQueue.defaultQueue().addPayment(payment);
      } else {
        print(validProduct.productIdentifier)
      }
    } else {
      print("nothing")
    }
  }
  
  
  func request(request: SKRequest, didFailWithError error: NSError) {
    print("Error Fetching product information");
  }
  
  func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])  {
    print("Received Payment Transaction Response from Apple");
    
    for transaction:AnyObject in transactions {
      if let trans = transaction as? SKPaymentTransaction {
        switch trans.transactionState {
        case .Purchasing:
          print("product Purchasing")
          break
        case .Purchased:
          print("Product Purchased")
          SKPaymentQueue.defaultQueue().finishTransaction(trans)
          NSUserDefaults.standardUserDefaults().setBool(true , forKey: PurchaseManager.PURCHASED_KEY)
          purchaseClouser()
          break;
        case .Failed:
          print("Purchased Failed")
          SKPaymentQueue.defaultQueue().finishTransaction(trans)
          break;
        case .Restored:
          print("Purchased restored")
          SKPaymentQueue.defaultQueue().finishTransaction(trans)
          NSUserDefaults.standardUserDefaults().setBool(true , forKey: PurchaseManager.PURCHASED_KEY)
          restoreClosure()
          break
        default:
          print(trans.transactionState.hashValue)
          break;
        }
      }
    }
    
  }
  
  func buy() {
    if SKPaymentQueue.canMakePayments() {
      SKPaymentQueue.defaultQueue().addTransactionObserver(self)
      let productsRequest = SKProductsRequest(productIdentifiers: NSSet(object: PurchaseManager.PRODUCT_ID) as! Set<String>)
      productsRequest.delegate = self
      productsRequest.start()
      print("Fething Products");
    } else {
      print("can't make purchases");
    }
  }
  
  func restore() {
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
  }
}

