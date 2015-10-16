//
//  OrganicCollectionViewController.swift
//  LocalPrayApp-ios
//
//  Created by Mazyad Alabduljaleel on 12/4/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


@objc protocol OrganicCollectionViewControllerDelegate {
    
    var items: [AnyObject] { get }
    var selectedIndex: Int { get }
    
    func organicCollectionViewStopped(atIndex index: Int)
}


class OrganicCollectionViewController: UICollectionViewController {

    unowned let delegate: OrganicCollectionViewControllerDelegate
    
    var deferLayout = false
    
    
    var selectedIndexPath: NSIndexPath = NSIndexPath() {
        didSet {
            if !scrollToSelectedIndexPath(animated: true) {
                deferLayout = true
            }
        }
    }
    
    var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    var collectionViewCellReuseIdentifier = "Cell"

    /* required UICollectionViewCell subclass to display your item */
    var cellClass: AnyClass! {
        didSet {
            collectionViewCellReuseIdentifier = NSStringFromClass(cellClass)
            
            collectionView!.registerClass(
                cellClass,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    var cellNib: UINib! {
        didSet {
            let cell = cellNib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
            collectionViewCellReuseIdentifier = cell.reuseIdentifier!
            
            collectionView!.registerNib(
                cellNib,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    // MARK: - Init & Dealloc
    
    init(delegate: OrganicCollectionViewControllerDelegate) {
        
        self.delegate = delegate
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        flowLayout.scrollDirection = .Horizontal
        
        let collectionView = self.collectionView!
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.frame = view.superview!.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if deferLayout && scrollToSelectedIndexPath(animated: false) {
            deferLayout = false
        }
    }
    
    // MARK: - Private methods
    
    private func scrollToSelectedIndexPath(animated animated: Bool) -> Bool {
        
        let attributes = flowLayout.layoutAttributesForItemAtIndexPath(selectedIndexPath) ?? UICollectionViewLayoutAttributes()
        
        if attributes.center == CGPoint.zero {
            return false
        }
        
        let offset = CGPoint(
            x: attributes.center.x - collectionView!.bounds.width / 2,
            y: collectionView!.contentOffset.y
        )
        
        collectionView!.setContentOffset(offset, animated: animated)
        return true
    }
    
    private func scrollViewStopped() {
        
        let xOffset = collectionView!.contentOffset.x
        let containerWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let roundedOffset = round((xOffset + (collectionView!.bounds.width - containerWidth)/2) / containerWidth) * containerWidth
        let index = Int(round(roundedOffset / containerWidth))
        
        delegate.organicCollectionViewStopped(atIndex: index)
    }
    
    // MARK: - UICollectionViewFlowLayoutDelegate methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemLength = collectionView.bounds.height
        return CGSize(width: itemLength, height: itemLength)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let bounds = collectionView.bounds
        let itemLength = bounds.height
        let controlWidth = bounds.width
        let inset = (controlWidth - itemLength) / 2

        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    // MARK: - UICollectionViewDataSource methods
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.items.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            collectionViewCellReuseIdentifier,
            forIndexPath: indexPath
            ) 
        
        if let organicCell = cell as? OrganicPickerCell {
            organicCell.setOrganicItem(delegate.items[indexPath.item])
        }
        else {
            assertionFailure("Registered Cell must conform to OrganicPickerCell protocol")
        }
        
        return cell
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            scrollViewStopped()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewStopped()
    }
    
}
