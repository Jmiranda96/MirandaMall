//
//  ItemDetailsViewController.swift
//  MirandaMall
//
//  Created by Jorge Miranda on 9/09/20.
//  Copyright © 2020 Jorge Miranda. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, ItemDetailsDelegate {
    
    

    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var buyButton: UIStackView!
    @IBOutlet weak var attributesTable: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mlImage: UIImageView!
    
    var id = String()
    
    var model = ItemDetailsModel()
    
    var mlURL = String()
    
    var conditons = [
        "new": "Nuevo",
        "used": "Usado"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attributesTable.delegate = self
        self.attributesTable.dataSource = self
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        self.model.delegate = self
        self.model.getDetails(id: self.id)
        setupLabel()
        setupMLButton()
        
    }
    
    func setupLabel() {
        itemPrice.textColor = UIColor(red: 0.52, green: 0.73, blue: 0.39, alpha: 1)
        itemPrice.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func setupMLButton() {
        self.mlImage.isUserInteractionEnabled = true
        self.mlImage.layer.cornerRadius = 15
        self.mlImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(urlHandler(_:))))
    }
    
    @objc func urlHandler(_ sender: UITapGestureRecognizer? = nil) {
        if let url = URL(string: self.mlURL) {
            UIApplication.shared.open(url)
        }
    }

    func setDetails() {
        DispatchQueue.main.async {
            self.imageCollection.reloadData()
            self.attributesTable.reloadData()
            self.setLabels()
            self.mlURL = self.model.detailInfo.permalink!
        }
    }
    
    func errorInRequest() {
        
    }
    
    func setLabels(){
        self.itemTitle.text = self.model.detailInfo.title
        self.itemPrice.text = String(self.model.detailInfo.price!) + " COP"
        self.itemDescription.text = conditons[self.model.detailInfo.condition!]! + " " + String(self.model.detailInfo.sold_quantity!) + " vendidos"
    }
    
    @IBAction func pressBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ItemDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.detailInfo.pictures?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemDetailsCell", for: indexPath) as! ItemDetailsCollectionViewCell
        
        cell.url = self.model.detailInfo.pictures![indexPath.row].secure_url!
        
        return cell
    }
}

extension ItemDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
}

extension ItemDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Detalles del producto"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = self.model.detailInfo.attributes?.count ?? 0
        tableHeightConstraint.constant = CGFloat(number*60) + 20
        return number
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "attributeCell", for: indexPath) as! ItemDetailsTableViewCell
        cell.attributeString = self.model.detailInfo.attributes![indexPath.row].name!
        cell.valueString = self.model.detailInfo.attributes![indexPath.row].value_name ?? "N/C"
        return cell
    }
}

