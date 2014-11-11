//
//  OrganicPickerSettingsCell.swift
//  OrganicPickerDemo
//
//  Created by Mazyad Alabduljaleel on 11/11/14.
//  Copyright (c) 2014 ArabianDevs. All rights reserved.
//

import UIKit

class OrganicPickerSettingsCell: UICollectionViewCell, OrganicPickerCell {

    @IBOutlet var label: UILabel?
    
    func setOrganicItem(item: AnyObject) {
        let string = item as String
        label?.text = string
    }
    
}
