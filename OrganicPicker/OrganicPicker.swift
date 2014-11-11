//
//  OrganicPicker.swift
//  OrganicPickerDemo
//
//  Created by Mazyad Alabduljaleel on 11/11/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


@objc protocol OrganicPickerDataSource {
    
    /* Length, because it can either be the content width or height */
    optional func contentLength() -> CGFloat
    
}

extension OrganicPicker /* Subclass Hooks */ {
    
}

public class OrganicPicker: UIView, UIScrollViewDelegate {
    
    /* contents are displayed within the picker. Can be anything */
    public var contents: [AnyObject] = []
    public var selectedIndex: Int = 0
    
    public var backgroundView: UIView? // optional background view
    public var maskingView: UIView? // optional mask
    
    let scrollView: UIScrollView = UIScrollView()
    let viewStore: [UIView] = []
    
    /** Organic picker can be customized by subclassing, delegation, or closures.
     *  Name your poison, and name it wisely.
     */

    /* Delegation */
    var dataSource: OrganicPickerDataSource?
    
    /* Closures */
    var contentWidthCalculator: (() -> (CGFloat))?
    
    
    // MARK: - Initialization
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    
    // MARK: - Private methods
    
    private func determineContentWidth() -> CGFloat {
        if let width = dataSource?.contentLength?() {
            return width
        }
        
        if let width = contentWidthCalculator?() {
            return width
        }
        
        if let views = contents as? [UIView] {
            return views.reduce(0) { $0 + $1.bounds.width }
        }
        
        assertionFailure("OrganicPicker: Unable to compute content width")
    }

    
    // MARK: - View lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        
        // this allows the first/last element to be centered in the scrollView
        let inset = scrollView.bounds.width / 2
        scrollView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        
        let contentWidth = determineContentWidth()
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
    }

    
    // MARK: - UIScrollViewDelegate methods
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }

}
