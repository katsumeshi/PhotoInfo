//
//  PhotoCollectionView.swift
//  photoinfo
//
//  Created by Yuki Matsushita on 10/25/15.
//  Copyright © 2015 Yuki Matsushita. All rights reserved.
//

import UIKit

protocol TapDelegate {
    func tap(selectedId:String)
}

class PhotoCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let REUSE_IDENTIFIER = "PhotoCollectionViewCell"
    
    var viewModel: PhotoListViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
        self.collectionViewLayout = getLayout()
        self.delegate = self
        self.dataSource = self
    }
    
    private func getLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 2;
        layout.itemSize = getCollectionItemSize()
        return layout
    }
    
    private func getCollectionItemSize() -> CGSize {
        return CGSize(width: (UIScreen.mainScreen().bounds.width / 4) - 2,
                      height: (UIScreen.mainScreen().bounds.width / 4) - 2)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        cell.rac_prepareForReuseSignal
        
        return cell
    }
    
}