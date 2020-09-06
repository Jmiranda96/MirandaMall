//
//  CategoryCollectionViewCell.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 6/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    var catInfo: categoryInfo! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI() {
        if let _ = catInfo {
            self.mainImage.image = catInfo.image
            self.mainLabel.text = catInfo.Title
        }
    }
    
}
