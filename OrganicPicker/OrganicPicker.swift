//
//  OrganicPicker.swift
//  OrganicPickerDemo
//
//  Created by Mazyad Alabduljaleel on 11/11/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


private extension CGRect {
    
    private var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
}

@objc protocol OrganicPickerDataSource {
    
}

@objc protocol OrganicPickerCell {
    func setOrganicItem(item: AnyObject)
}

class OrganicPicker: UIControl, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /* items are displayed within the picker. Can be anything */
    var items: [AnyObject] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /* required UICollectionViewCell subclass to display your item */
    var collectionViewCellClass: AnyClass? {
        didSet {
            collectionView.registerClass(
                collectionViewCellClass,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    var collectionViewCellNib: UINib? {
        didSet {
            let cell = collectionViewCellNib?.instantiateWithOwner(nil, options: nil)[0] as UICollectionViewCell
            collectionViewCellReuseIdentifier = cell.reuseIdentifier
            
            collectionView.registerNib(
                collectionViewCellNib,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
            let attributes = collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath)
            let offset = CGPoint(
                x: attributes.center.x - collectionView.bounds.width / 2,
                y: collectionView.contentOffset.y
            )
            
            collectionView.setContentOffset(offset, animated: true)
        }
    }
    
    @IBInspectable var itemSpacing: CGFloat = 2
    
    var backgroundView: UIView?
    var foregroundView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = foregroundView {
                view.userInteractionEnabled = false
                addSubview(view)
            }
        }
    }
    
    var maskingLayer: CALayer? {
        didSet {
            layer.mask = maskingLayer
            layer.masksToBounds = true
        }
    }
    
    let collectionView: UICollectionView = UICollectionView(
        frame: CGRect(x: 0, y: 0, width: 100, height: 100),
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    var collectionViewLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as UICollectionViewFlowLayout
    }
    
    var collectionViewCellReuseIdentifier = "Cell"
    
    /** Organic picker can be customized by subclassing, delegation, or closures.
     *  Name your poison, and name it wisely.
     */

    /* Delegation */
    var dataSource: OrganicPickerDataSource?
    
    /* Closures */
    
    
    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required override init() {
        super.init()
        commonInit()
    }
    
    private func commonInit() {
        
        clipsToBounds = true
        
        collectionViewLayout.scrollDirection = .Horizontal
        
        let collectionView = self.collectionView
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            collectionView.backgroundColor = UIColor.clearColor()
            collectionView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.scrollsToTop = false
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            
            self.addSubview(collectionView)
            
            collectionView.reloadData()
        })
    }
    
    
    // MARK: - Private methods
    
    private func scrollViewStopped() {
        
        let xOffset = collectionView.contentOffset.x
        let containerWidth = collectionViewLayout.itemSize.width + collectionViewLayout.minimumInteritemSpacing
        let roundedOffset = round((xOffset + (collectionView.bounds.width - containerWidth)/2) / containerWidth) * containerWidth;
        let index = Int(round(roundedOffset / containerWidth))

        selectedIndex = index
        sendActionsForControlEvents(.ValueChanged)
    }
    
    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskingLayer?.frame = bounds
        foregroundView?.frame = bounds
        
        if let view = foregroundView {
            bringSubviewToFront(view)
        }
        
        collectionView.frame = self.bounds
        
        let itemLength = bounds.height
        collectionViewLayout.itemSize = CGSize(width: itemLength, height: itemLength)

        // this allows the first/last element to be centered in the scrollView
        let inset = (bounds.width - itemLength) / 2
        collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
    }

    
    // MARK: - UICollectionViewDataSource methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            collectionViewCellReuseIdentifier,
            forIndexPath: indexPath
        ) as UICollectionViewCell
        
        if let organicCell = cell as? OrganicPickerCell {
            organicCell.setOrganicItem(items[indexPath.item])
        }
        else {
            assertionFailure("Registered Cell must conform to OrganicPickerCell protocol")
        }
        
        return cell 
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    // MARK: - UIScrollViewDelegate methods
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewStopped();
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewStopped();
    }

}
