//
//  ItemDetailsTableViewCell.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 10/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var attributeString: String = "" {
        didSet {
            self.attributeLabel.text = attributeString
        }
    }
    var valueString: String = "" {
        didSet {
            self.valueLabel.text = valueString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
