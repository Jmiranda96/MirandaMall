//
//  ItemListTableViewCell.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 8/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UrlImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var itemInfo: MLServices.MLSearchResult? {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override func prepareForReuse() {
        self.loader.startAnimating()
        self.itemImage.image = nil
    }
    
    func setup() {
        // 85bb65
        itemPrice.textColor = UIColor(red: 0.52, green: 0.73, blue: 0.39, alpha: 1)
        itemPrice.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.itemTitle.text = ""
        self.itemPrice.text = ""
        self.loader.hidesWhenStopped = true
        self.loader.startAnimating()
    }

    func updateUI() {
        if let info = itemInfo {
            self.itemTitle.text = info.title
            self.itemPrice.text = String(info.price!) + " COP"
            guard let imgUrl = info.thumbnail else {
                self.loader.startAnimating()
                return
            }
            self.loader.stopAnimating()
            self.itemImage.loadImageFromUrl(imgUrl)
        }
    }
    
}
