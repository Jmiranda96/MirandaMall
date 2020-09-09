//
//  ItemListViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 8/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController, ItemListDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var itemListTableView: UITableView!
    var url = String()
    var categoryID = String()
    
    var model = ItemListModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.itemListTableView.dataSource = self
        self.itemListTableView.delegate = self
        self.model.delegate = self
        
        self.model.getItems(byCategory: categoryID, bySearch: url)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setItems() {
        self.itemListTableView.reloadData()
    }
    

    @IBAction func pressBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ItemListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // perform segue to item list page with the search query in the sender
        self.performSegue(withIdentifier: "showItemsList", sender: ["search":searchBar.text])
    }
}

// MARK: - UICollectionViewDelegate

extension ItemListViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.model.itemList.count > 0 ? self.model.itemList.count : 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath) as! ItemListTableViewCell

        guard self.model.itemList.count > 0 else {
            return cell
        }
        
        let info = self.model.itemList[indexPath.row]
        
        cell.itemInfo = info
        return cell
    }
    
    
}

extension ItemListViewController: UITableViewDelegate {
    
}

