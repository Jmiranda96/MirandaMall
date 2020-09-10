//
//  ItemDetailsCollectionViewCell.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 10/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainImage: UrlImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var url: String? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        self.mainImage.image = UIImage(named: "placeholder200")
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
        if let _ = url {
            loader.stopAnimating()
            self.mainImage.loadImageFromUrl(url!)
        }
    }
}
