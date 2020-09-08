//
//  ItemListViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 8/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var urlLabel: UILabel!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    var url = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        urlLabel.text = url
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
