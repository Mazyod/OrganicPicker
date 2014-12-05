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
    
    var selectedIndex: Int = 0 {
        didSet {
            let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
            collectionViewController.selectedIndexPath = indexPath
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
    
    
    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskingLayer?.frame = bounds
        foregroundView?.frame = bounds
        
        if let view = foregroundView {
            bringSubviewToFront(view)
        }
    }

    // MARK: - OrganicCollectionViewDelegate
    
    func organicCollectionViewStopped(atIndex index: Int) {
        
        selectedIndex = index
        sendActionsForControlEvents(.ValueChanged)
    }
    
}
