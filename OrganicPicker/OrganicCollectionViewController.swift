//
//  OrganicCollectionViewController.swift
//  LocalPrayApp-ios
//
//  Created by Mazyad Alabduljaleel on 12/4/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


@objc protocol OrganicCollectionViewControllerDelegate {
    
    var items: [String] { get }
    var selectedIndex: Int { get }
    
    func organicCollectionViewStopped(atIndex index: Int)
}


class OrganicCollectionViewController: UICollectionViewController {

    unowned let delegate: OrganicCollectionViewControllerDelegate
    
    var deferLayout = false
    
    
    var selectedIndexPath: IndexPath = IndexPath() {
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
            
            collectionView!.register(
                cellClass,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    var cellNib: UINib! {
        didSet {
            let cell = cellNib.instantiate(withOwner: nil, options: nil)[0] as! UICollectionViewCell
            collectionViewCellReuseIdentifier = cell.reuseIdentifier!
            
            collectionView!.register(
                cellNib,
                forCellWithReuseIdentifier: collectionViewCellReuseIdentifier
            )
        }
    }
    
    // MARK: - Init & Dealloc
    
    init(delegate: OrganicCollectionViewControllerDelegate) {
        
        self.delegate = delegate
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = self.collectionView!
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    fileprivate func scrollToSelectedIndexPath(animated: Bool) -> Bool {
        
        let attributes = flowLayout.layoutAttributesForItem(at: selectedIndexPath) ?? UICollectionViewLayoutAttributes()
        
        guard attributes.frame != CGRect.zero else {
            return false
        }
        
        let collectionView = self.collectionView!
        
        let offset = CGPoint(
            x: attributes.center.x - collectionView.bounds.width / 2,
            y: collectionView.contentOffset.y
        )
        
        collectionView.setContentOffset(offset, animated: animated)
        
        return true
    }
    
    fileprivate func scrollViewStopped() {
        
        let collectionView = self.collectionView!
        var point = collectionView.contentOffset
        point.x += collectionView.bounds.width / 2
        
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        selectedIndexPath = indexPath
        delegate.organicCollectionViewStopped(atIndex: (indexPath as NSIndexPath).item)
    }
    
    // MARK: - UICollectionViewFlowLayoutDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let itemLength = collectionView.bounds.height
        return CGSize(width: itemLength, height: itemLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let bounds = collectionView.bounds
        let itemLength = bounds.height
        let controlWidth = bounds.width
        let inset = (controlWidth - itemLength) / 2

        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    // MARK: - UICollectionViewDataSource methods
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionViewCellReuseIdentifier,
            for: indexPath
            ) 
        
        if let organicCell = cell as? OrganicPickerCell {
            organicCell.setOrganicItem(delegate.items[indexPath.item] as AnyObject)
        }
        else {
            assertionFailure("Registered Cell must conform to OrganicPickerCell protocol")
        }
        
        return cell
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            scrollViewStopped()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewStopped()
    }
    
}
