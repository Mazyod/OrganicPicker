//
//  ViewController.swift
//  OrganicPickerDemo
//
//  Created by Mazyad Alabduljaleel on 11/11/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit


private class ForegroundView: UIView {
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    init(color: UIColor) {
        super.init(frame: CGRectZero)
        
        let gradientLayer = layer as CAGradientLayer
        gradientLayer.cornerRadius = 25
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations = [
            CGFloat(0.1),
            CGFloat(0.5),
            CGFloat(0.9)
        ]
        gradientLayer.colors = [
            color.CGColor,
            color.colorWithAlphaComponent(0).CGColor,
            color.CGColor,
        ]
        
        backgroundColor = UIColor.clearColor()
        contentMode = .Redraw
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var rect = CGRect(x: 40, y: 150, width: 200, height: 50)

        let controlColor = UIColor(red: 0.824, green: 0.882, blue: 0.906, alpha: 1)
        
        let picker = OrganicPicker(frame: rect)
        picker.collectionViewCellNib = UINib(nibName: "OrganicPickerSettingsCell", bundle:nil)
        picker.backgroundColor = controlColor
        picker.foregroundView = ForegroundView(color: controlColor)
        picker.layer.cornerRadius = 25
        picker.items = (1...15).map { "\($0)" }
        
        view.addSubview(picker)
        
        let marker = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 60))
        marker.backgroundColor = UIColor.redColor()
        marker.center = CGPointMake(rect.midX, rect.midY)
        view.addSubview(marker)
    }

}

