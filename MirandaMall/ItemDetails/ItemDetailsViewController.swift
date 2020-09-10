//
//  ItemDetailsViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 9/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var buyButton: UIStackView!
    @IBOutlet weak var attributesTable: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attributesTable.delegate = self
        self.attributesTable.dataSource = self
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self

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

extension ItemDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemDetailsCell", for: indexPath) as! ItemDetailsCollectionViewCell
        cell.url = "https://mco-s1-p.mlstatic.com/944573-MCO32558013892_102019-O.jpg"
        return cell
    }
}

extension ItemDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = 2
        tableHeightConstraint.constant = 6*50
        return number
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as! ItemDetailsTableViewCell
        cell.attributeString = "Attribute"
        cell.valueString = String(indexPath.row)
        return cell
    }
}

