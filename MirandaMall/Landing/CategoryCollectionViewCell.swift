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
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var catInfo: MLServices.MLCategoryDetails? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override func prepareForReuse() {
        self.loader.startAnimating()
        self.mainImage.image = nil
    }
    
    func setup() {
        self.loader.hidesWhenStopped = true
        self.loader.startAnimating()
    }
    
    func updateUI() {
        if let info = catInfo {
            self.mainLabel.text = info.name
        }
    }
    
}
