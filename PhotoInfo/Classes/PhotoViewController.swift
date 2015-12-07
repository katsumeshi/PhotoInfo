
//
//  PhotoViewController.swift
//  photomap
//
//  Created by Yuki Matsushita on 5/5/15.
//  Copyright (c) 2015 Yuki Matsushita. All rights reserved.
//

import UIKit
import Photos
import Social
import ReactiveCocoa


class PhotoListViewController: UIViewController,
  UICollectionViewDelegate,
  UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var collectionView: UICollectionView?
  @IBOutlet weak var sortingButton: UIBarButtonItem?
  
  private let REUSE_IDENTIFIER = "PhotoCollectionViewCell"
  private(set) var viewModel = PhotoListViewModel(PhotoLoader().photos)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let photoLibraryAutorizedSignal = NSNotificationCenter.addObserver(PHPhotoLibrary.AuthorizedKey)
    photoLibraryAutorizedSignal.toSignalProducer()
      .observeOn(UIScheduler())
      .startWithNext { _ in
        
        self.viewModel = PhotoListViewModel(PhotoLoader().photos)
        self.viewModel.photos.producer
          .observeOn(UIScheduler())
          .on(next: { _ in
            self.collectionView?.reloadData()
          }).start()
    }
  }
  
  
  // MARK: - UIViewController Methods
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel.reload(PhotoLoader().photos)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sortingButton!.rac_command = RACCommand(signalBlock: { sender -> RACSignal! in
      self.showSortingActionSheet(sender as! UIBarButtonItem)
      return RACSignal.empty()
    })
    
    self.rac_signalForSelector("collectionView:didSelectItemAtIndexPath:",
      fromProtocol: UICollectionViewDelegate.self)
      .toSignalProducer()
      .map { (tuple) -> Photo in
        return self.getSelectedPhoto(tuple!)
      }.startWithNext {
        self.transferExifViewController($0)
    }
    
    collectionView!.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    collectionView!.collectionViewLayout = getCollectionViewLayout()
    collectionView!.delegate = self
    collectionView!.dataSource = self
  }
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.photos.value.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as! PhotoCollectionViewCell
    
    let photo = viewModel.photos.value[indexPath.item]
    cell.bind(photo)
    
    return cell
  }
  
  // MARK: - Cusotm Methods
  
  func transferExifViewController(photo:Photo) {
    let exifViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ExifViewController") as! ExifViewController
    exifViewController.viewModel = ExifViewModel(photo)
    self.navigationController?.pushViewController(exifViewController, animated: true)
  }
}


extension PhotoListViewController {
  
  // MARK: - Private Methods
  
  private func getSelectedPhoto(tuple:AnyObject) -> Photo {
    let indexPath = (tuple as! RACTuple).second
    let index = (indexPath as! NSIndexPath).item
    return self.viewModel.photos.value[index]
  }
  
  private func showSortingActionSheet(sender:UIBarButtonItem) {
    
    let alertController = UIAlertController(title: "Sorting".toGrobal(), message: "", preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel".toGrobal(), style: .Cancel, handler: nil)
    let geoSortlAction = UIAlertAction(title: "Geotag".toGrobal(), style: .Default, handler: {
      _ in
      self.viewModel.sortGeo()
    })
    
    let dateSortAction = UIAlertAction(title: "Creation Date".toGrobal(), style: .Default, handler: {
      _ in
      self.viewModel.sortDate()
    })
    
    alertController.addAction(cancelAction)
    alertController.addAction(geoSortlAction)
    alertController.addAction(dateSortAction)
    
    // popoverPresentationController for iPad
    alertController.popoverPresentationController?.barButtonItem = sender
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  private func getCollectionViewLayout() -> UICollectionViewFlowLayout {
    let bounds = UIScreen.mainScreen().bounds
    let size = (bounds.width / 4) - 2
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: size, height: size)
    layout.minimumLineSpacing = 2
    layout.minimumInteritemSpacing = 2
    return layout
  }
  
}