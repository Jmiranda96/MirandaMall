//
//  LandingViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 6/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, LandingDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var logoImage: UIImageView!
    
    let model: LandingModel = LandingModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        self.searchBar.delegate = self
        self.categoryCollection.dataSource = self
        self.categoryCollection.delegate = self
        
        // Call to get the categories from services
        self.model.getCategories()
        
        //tap gesture implemented to dismiss keyboard
        self.dismissKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.text = ""
        self.searchBar.placeholder = "Que quieres vitrinear?"
    }
    
    // function called to update size of CollectionViewCells after change of orientation
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        
        
        if let layout = categoryCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
    // MARK: - LandingDelegate
    func setCategories() {
        //update of category list in main thread
        DispatchQueue.main.async {
            self.categoryCollection.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemListViewController {
            
            // Check the format of sender to config the variables for next Vc
            
            if let senderInfo = sender as? [String:String?] {
                if let searchQuery = senderInfo["search"]  {
                    vc.query = searchQuery!
                }
            }
            
            if let senderInfo = sender as? [String:MLServices.MLCategoryDetails] {
                if let categoryQuery = senderInfo["catInfo"] {
                    vc.categoryInfo = categoryQuery
                }
            }
        }
    }

}

// MARK: - UISearchBarDelegate

extension LandingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // perform segue to item list page with the search query in the sender
        guard !searchBar.text!.isEmpty else {return}
        self.performSegue(withIdentifier: "showItemsList", sender: ["search":searchBar.text])
    }
}


// MARK: - UICollectionViewDelegate

extension LandingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.model.catList.count > 0 ? self.model.catList.count : 8
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        guard self.model.catList.count > 0 else {
            return cell
        }
        cell.catInfo = self.model.catList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showItemsList", sender: ["catInfo":self.model.catList[indexPath.row]])
    }
}

extension LandingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.height*0.35, height: self.view.frame.height*0.35)
    }
}
