//
//  LandingViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 6/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let mockInfo: [categoryInfo] = {
        let mock1 = categoryInfo(Title: "Cat1", image: UIImage(named: "Agro")!)
        let mock2 = categoryInfo(Title: "Cat2", image: UIImage(named: "Alimentos")!)
        let mock3 = categoryInfo(Title: "Cat3", image: UIImage(named: "Mascotas")!)
        let mock4 = categoryInfo(Title: "Cat4", image: UIImage(named: "AutosAccesorios")!)
        return [mock1,mock2,mock3,mock4,mock1,mock2,mock3,mock4]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}



extension LandingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.mockInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.catInfo = self.mockInfo[indexPath.row]
        return cell
    }
}

extension LandingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.height*0.4, height: self.view.frame.height*0.4)
    }
}
