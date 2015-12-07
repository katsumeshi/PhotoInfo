
//
//  ViewController.swift
//  photomap
//
//  Created by Yuki Matsushita on 5/5/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import MapKit
import ReactiveCocoa

class ExifViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var mapView: MKMapView?
  @IBOutlet weak var tableView: UITableView?
  
  var viewModel: ExifViewModel!
  private(set) var editingAction:CocoaAction!
  
  
  // MARK: - UIViewController Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.photo.requestAnnotation().on(failed: { [weak self] _ in
      self?.showTransfarEditingAlert()
      }, next: { [weak self] (annotation) in
        self?.mapView?.addAnnotation(annotation)
        self?.mapView?.centerOnMap(annotation)
      }).start()
    
    editingAction = CocoaAction(Action<Void, Void, NoError> { [weak self] _ in
      self?.transferMapViewController(self!.viewModel.photo)
      return SignalProducer.empty
      }, input:())
    
    viewModel.exifParser.producer.startWithNext { [weak self] _ in
      self?.tableView?.reloadData()
    }
    
    mapView?.delegate = self
    tableView?.delegate = self
    tableView?.dataSource = self
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.popToRootViewControllerAnimated(false)
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
    let customPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinIdentifier")
    customPinView.animatesDrop = true
    customPinView.canShowCallout = true
    customPinView.rightCalloutAccessoryView = generateButton()
    
    let customAnnotation = annotation as! CustomAnnotation
    customPinView.leftCalloutAccessoryView = generateImageView(customAnnotation.image)
    
    return customPinView
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return viewModel.exifParser.value.categories.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.exifParser.value.categories[section].contents.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("ExifDetailTableViewCell", forIndexPath: indexPath) as! ExifDetailTableViewCell
    
    let categories = viewModel.exifParser.value.categories[indexPath.section]
    let content = categories.contents[indexPath.item]
    cell.keyLabel?.text = content.key.toGrobal()
    cell.valueLabel?.text = content.value
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label: UILabel = UILabel()
    let category = viewModel.exifParser.value.categories[section]
    label.text = category.name.toGrobal()
    label.backgroundColor = UIColor(red:52/255.0, green:152/255.0, blue:219/255.0, alpha:1)
    label.textColor = UIColor.whiteColor()
    label.textAlignment = NSTextAlignment.Center
    return label
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
  
}

extension ExifViewController {
  
  // MARK: - Private Methods
  
  private func generateButton() -> UIButton {
    let uiButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let editImage = UIImage.fontAwesomeIconWithName(.Edit, textColor:UIColor.blackColor(),
      size: CGSize(width: 40, height: 40))
    
    uiButton.setImage(editImage, forState: UIControlState.Normal)
    uiButton.addTarget(editingAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    return uiButton
  }
  
  private func generateImageView(image:UIImage) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.frame.size = CGSize(width: 50, height: 50)
    return imageView
  }
  
  private func transferMapViewController(photo:Photo) {
    self.tabBarController?.selectedIndex = TabType.Map.rawValue
    let navigationController = tabBarController?.selectedViewController.map {
      $0 as! UINavigationController
    }
    let mapViewController = navigationController?.viewControllers.first.map {
      $0 as! MapViewController
    }
    
    if let _ = photo.location {
      mapViewController?.selectAnnotation(photo)
    } else {
      mapViewController?.addNewAnnotation(photo)
    }
  }
  
  private func showTransfarEditingAlert() {
    
    let alertController = UIAlertController(title: "Confirmation".toGrobal(),
      message: "None of the location information. Do you change the location?".toGrobal(),
      preferredStyle: UIAlertControllerStyle.Alert)
    
    
    let yesAction = UIAlertAction(title: "Yes".toGrobal(), style: .Default) { _ in
      self.transferMapViewController(self.viewModel.photo)
    }
    
    let noAction = UIAlertAction(title: "No".toGrobal(), style: .Default, handler: nil)
    
    alertController.addAction(noAction)
    alertController.addAction(yesAction)
    
    self.presentViewController(alertController, animated: true, completion: nil)
    
  }
}