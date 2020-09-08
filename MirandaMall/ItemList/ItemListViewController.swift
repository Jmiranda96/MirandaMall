//
//  ItemListViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 8/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController, ItemListDelegate {
    @IBOutlet weak var itemListCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var url = String()
    var categoryID = String()
    
    var model = ItemListModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.itemListCollection.dataSource = self
        self.itemListCollection.delegate = self
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
        self.itemListCollection.reloadData()
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

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.model.itemList.count > 0 ? self.model.itemList.count : 8

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell

        guard self.model.itemList.count > 0 else {
            return cell
        }
        
        let info = self.model.itemList[indexPath.row]
        
        cell.catInfo =  MLServices.MLCategoryDetails(id: info.id, name: info.title, picture: info.thumbnail)
        return cell
    }
}

extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.4, height: self.view.frame.width*0.4)
    }
}
