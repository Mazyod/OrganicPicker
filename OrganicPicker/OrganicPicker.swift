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

class OrganicPicker: UIControl, OrganicCollectionViewControllerDelegate {
    
    lazy var collectionViewController: OrganicCollectionViewController = {
        OrganicCollectionViewController(delegate: self)
    }()
    
    /* items are displayed within the picker. Can be anything */
    var items: [AnyObject] = [] {
        didSet {
            collectionViewController.collectionView?.reloadData()
        }
    }
    
    /* required UICollectionViewCell subclass to display your item */
    var collectionViewCellClass: AnyClass? {
        didSet {
            collectionViewCellReuseIdentifier = collectionViewCellClass!.description()
            
            collectionViewController.collectionView!.registerClass(
                collectionViewCellClass,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    var collectionViewCellNib: UINib? {
        didSet {
            let cell = collectionViewCellNib?.instantiateWithOwner(nil, options: nil)[0] as UICollectionViewCell
            collectionViewCellReuseIdentifier = cell.reuseIdentifier
            
            collectionViewController.collectionView!.registerNib(
                collectionViewCellNib,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            
        }
    }
    
    @IBInspectable var itemSpacing: CGFloat = 2
    
    var backgroundView: UIView?
    var foregroundView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = foregroundView {
                view.frame = bounds
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
        
    var collectionViewCellReuseIdentifier = "Cell"
    
    /** Organic picker can be customized by subclassing, delegation, or closures.
     *  Name your poison, and name it wisely.
     */

    /* Delegation */
    var dataSource: OrganicPickerDataSource?
    
    
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
    
    func commonInit() {
        clipsToBounds = true
        
        addSubview(collectionViewController.view)
    }
    
    
    // MARK: - Private methods
    
    private func collectionViewScrollCallback(index: Int) {
        
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
    
}
