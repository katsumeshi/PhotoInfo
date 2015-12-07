//
//  MapViewController.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 11/16/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import ReactiveCocoa
import Photos
import ReactiveUI

class NewAnnotation: NSObject, MKAnnotation {
  var coordinate:CLLocationCoordinate2D
  init(_ coordinate:CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
}

class MapViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView?
  
  var viewModel:MapViewModel!
  private(set) var callOutButton = UIButton(type: .InfoLight)
  private var isEditable = false
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let photoLibraryAutorizedSignal = NSNotificationCenter.addObserver(PHPhotoLibrary.AuthorizedKey)
    photoLibraryAutorizedSignal.toSignalProducer()
      .observeOn(UIScheduler())
      .startWithNext { _ in
        self.viewModel = MapViewModel(PhotoLoader().photos)
    }
  }
  
  
  // MARK: - UIViewController Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    callOutButton.rac_command = RACCommand(signalBlock: { sender -> RACSignal! in
      self.showPhotoLocationEditingActionSheet(sender as! UIButton)
      return RACSignal.empty()
    })
    
    self.rac_signalForSelector("mapView:didSelectAnnotationView:",
      fromProtocol: MKMapViewDelegate.self)
      .toSignalProducer()
      .map { (tuple) -> CustomAnnotation in
        let annotationView = (tuple as! RACTuple).second
        let annotation = (annotationView as! MKAnnotationView).annotation
        let customAnnotation = annotation as! CustomAnnotation
        return customAnnotation
      }.startWithNext {
        self.viewModel.select($0.photo)
    }
    
    self.view.addGestureRecognizer(
      UITapGestureRecognizer { (recognizer) -> () in
        if !self.isEditable {
          return
        }
        
        let point = recognizer.locationOfTouch(0, inView: self.view)
        let coordinate = self.mapView?.convertPoint(point, toCoordinateFromView: self.mapView)
        self.mapView?.addAnnotation(NewAnnotation(coordinate!))
      })
    
    mapView?.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.annotations.producer.startWithNext {
      self.calculateCenterOnMap()
      self.mapView?.removeAnnotations(self.mapView!.annotations)
      self.mapView?.addAnnotations($0)
    }
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
    if let customAnnotation = annotation as? CustomAnnotation {
      return createImagePinView(customAnnotation)
    } else {
      CLGeocoder.getPlace(annotation).startWithNext {
        self.showConfirmationAlert($0.address, annotation: annotation)
        self.isEditable = false
      }
      return createAnimationPinView(annotation)
    }
  }
  
  // MARK: - Cusotm Methods
  
  func selectAnnotation(photo:Photo) {
    mapView?.selectedAnnotations.forEach {
      mapView?.deselectAnnotation($0, animated: false)
    }
    let annotation = viewModel.annotations.value.find(photo).annotation
    mapView?.selectAnnotation(annotation, animated: true)
    mapView?.centerOnMap(annotation)
  }
  
  func addNewAnnotation(photo:Photo) {
    isEditable = true
    viewModel.select(photo)
  }
}


extension MapViewController {
  
  // MARK: - Private Methods
  
  private func calculateCenterOnMap() {
    if let region = viewModel.getCenterRegionOnMap() where canCenterizeOnMap() {
      mapView!.setRegion(region, animated: true)
    }
  }
  
  private func canCenterizeOnMap() -> Bool {
    return mapView?.annotations.count == 0
  }
  
  private func showPhotoLocationEditingActionSheet(sender:UIButton) {
    
    let alertController = UIAlertController(title: "Option".toGrobal(),
      message: "",
      preferredStyle: .ActionSheet)
    
    let detailAction = UIAlertAction(title: "Detail".toGrobal(), style: .Default) {  _ in
      self.transferExifViewController(self.viewModel.selectingPhoto!)
    }
    let editAction = UIAlertAction(title: "Edit".toGrobal(), style: .Default) { _ in
      self.isEditable = true
    }
    let deleteAction = UIAlertAction(title: "Delete".toGrobal(), style: .Default) { _ in
      self.viewModel.delete()
    }
    let cancelAction = UIAlertAction(title: "Cancel".toGrobal(), style: .Cancel, handler: nil)
    
    alertController.addAction(detailAction)
    alertController.addAction(editAction)
    alertController.addAction(deleteAction)
    alertController.addAction(cancelAction)
    
    // popoverPresentationController for iPad
    alertController.popoverPresentationController?.sourceView = sender
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  
  private func transferExifViewController(photo:Photo) {
    self.tabBarController?.selectedIndex = TabType.List.rawValue
    let navigationController =  self.tabBarController?.selectedViewController.map {
      return $0  as! UINavigationController
    }
    let photoListViewController = navigationController?.viewControllers.first.map {
      $0 as! PhotoListViewController
    }
    photoListViewController!.transferExifViewController(photo)
  }
  
  private func showConfirmationAlert(address:String, annotation: MKAnnotation) {
    let alertController = UIAlertController(title: "Confirmation".toGrobal(),
      message: "「\(address)" + "」Do you change here?".toGrobal() , preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "Yes".toGrobal(), style: .Default) { _ in
      self.viewModel.update(annotation.coordinate).startWithNext {
        self.viewModel.reload(PhotoLoader().photos)
      }
    }
    
    let cancelAction = UIAlertAction(title: "No".toGrobal() , style: .Cancel) { _ in
      let annotation = self.mapView!.annotations.filter { $0 is NewAnnotation }
      self.mapView?.removeAnnotation(annotation.first!)
    }
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  private func createAnimationPinView(annotation: MKAnnotation) -> MKAnnotationView {
    let customPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
    customPinView.animatesDrop = true
    return customPinView
  }
  
  private func createImagePinView(customAnnotation:CustomAnnotation) -> MKAnnotationView {
    let customPinView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: "")
    customPinView.image = customAnnotation.image.resize(CGSize(width: 30, height: 30))
    customPinView.canShowCallout = true
    customPinView.rightCalloutAccessoryView = callOutButton
    return customPinView
  }
}

extension CLLocation {
  convenience init (_ coodinate:CLLocationCoordinate2D) {
    self.init(latitude: coodinate.latitude, longitude: coodinate.longitude)
  }
}
