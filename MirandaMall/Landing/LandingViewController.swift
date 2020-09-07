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
    
    let mlServices = MLServices()
    let model = LandingModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        self.model.getCategories()
        self.categoryCollection.dataSource = self
        self.categoryCollection.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if let layout = categoryCollection.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.invalidateLayout()
//        }
//    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let layout = categoryCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setCategories() {
        DispatchQueue.main.async {
            self.categoryCollection.reloadData()
        }
    }

}



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
}

extension LandingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.height*0.4, height: self.view.frame.height*0.4)
    }
}
