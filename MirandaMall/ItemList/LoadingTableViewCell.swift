//
//  LoadingTableViewCell.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 9/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
