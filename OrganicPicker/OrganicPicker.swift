//
//  OrganicPicker.swift
//  OrganicPickerDemo
//
//  Created by Mazyad Alabduljaleel on 11/11/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


@objc protocol OrganicPickerCell {
    func setOrganicItem(_ item: Any)
}

class OrganicPicker: UIControl, OrganicCollectionViewControllerDelegate {
    
    lazy var collectionViewController = OrganicCollectionViewController(delegate: self)
    
    var items: [String] = [] {
        didSet {
            
            guard items != oldValue else {
                return
            }
            
            collectionViewController.collectionView?.reloadData()
        }
    }
    
    var selectedIndex: Int = -1 {
        didSet {
            
            guard selectedIndex != oldValue else {
                return
            }
            
            accessibilityValue = items[selectedIndex]
            
            let indexPath = IndexPath(item: selectedIndex, section: 0)
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
                view.isUserInteractionEnabled = false
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
    
    /** Organic picker can be customized by subclassing or closures.
     *  Name your poison, and name it wisely.
     */
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func commonInit() {
        
        isAccessibilityElement = true
        accessibilityNavigationStyle = .combined
        accessibilityHint = NSLocalizedString("ACCESS_ORGANIC_PICKER_HINT", comment: "")
        
        clipsToBounds = true
        
        addSubview(collectionViewController.view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OrganicPicker.controlTapped(_:)))
        tapGesture.require(toFail: collectionViewController.collectionView!.panGestureRecognizer)
        
        addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - View lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if collectionViewController.view.bounds.size != bounds.size {
            collectionViewController.view.frame = bounds
        }
        
        maskingLayer?.frame = bounds
        foregroundView?.frame = bounds
        
        if let view = foregroundView {
            bringSubviewToFront(view)
        }
    }
    
    // MARK: - Action
    
    @objc func controlTapped(_ gesture: UITapGestureRecognizer?) {
        
        // allow rolling through options for accessibility sake
        selectedIndex = (selectedIndex + 1) % items.count
        sendActions(for: .valueChanged)
    }

    // MARK: - OrganicCollectionViewDelegate
    
    func organicCollectionViewStopped(atIndex index: Int) {
        
        selectedIndex = index
        sendActions(for: .valueChanged)
    }
    
}
