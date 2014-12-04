//
//  OrganicCollectionViewController.swift
//  LocalPrayApp-ios
//
//  Created by Mazyad Alabduljaleel on 12/4/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


@objc protocol OrganicCollectionViewControllerDelegate {
    
    var selectedIndex: Int { get }
    
}

class OrganicCollectionViewController: UICollectionViewController {

    unowned let delegate: OrganicCollectionViewControllerDelegate
    
    var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as UICollectionViewFlowLayout
    }
    
    init(delegate: OrganicCollectionViewControllerDelegate) {
        self.delegate = delegate
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        flowLayout.scrollDirection = .Horizontal
        
        let collectionView = self.collectionView!
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.frame = view.superview!.bounds
        
        let itemLength = view.bounds.height
        flowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        
        // this allows the first/last element to be centered in the scrollView
        let inset = (view.bounds.width - itemLength) / 2
        collectionView!.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        
        let indexPath = NSIndexPath(forItem: delegate.selectedIndex, inSection: 0)
        collectionView!.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)

    }
    
    private func scrollViewStopped() {
        
        let xOffset = collectionView!.contentOffset.x
        let containerWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let roundedOffset = round((xOffset + (collectionView!.bounds.width - containerWidth)/2) / containerWidth) * containerWidth;
        let index = Int(round(roundedOffset / containerWidth))
        
        
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        
        if !decelerate {
            scrollViewStopped();
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        
        scrollViewStopped();
    }
    
}
