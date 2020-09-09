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
    @IBOutlet weak var tableBottonConstraint: NSLayoutConstraint!
    
    var url = String()
    var categoryInfo = MLServices.MLCategoryDetails()
    
    var model = ItemListModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.itemListTableView.dataSource = self
        self.itemListTableView.delegate = self
        self.model.delegate = self
        
        //the items list is fetched by the category and/or search text
        self.model.getItems(byCategory: categoryInfo.id!, bySearch: url)
        
        //tap gesture implemented to dismiss keyboard
        self.dismissKeyboardOnTap()
        
        // Notification subscription to get keyboard height and adjust table bounds
        notificationSetup()
        
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
    
    // MARK: -  Notification (keyboardDidChange)
    
    func notificationSetup(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableBottonConstraint.constant = keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.tableBottonConstraint.constant = 0
    }
    
    
    
}

// MARK: - UISearchBarDelegate

extension ItemListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // perform segue to item list page with the search query in the sender
        self.performSegue(withIdentifier: "showItemsList", sender: ["search":searchBar.text])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDelegate

extension ItemListViewController: UITableViewDataSource {
   
    
    // Check if the categoryInfo is provided to display header in section with the name of the category searched
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryInfo.id!.isEmpty ? "" : categoryInfo.name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return categoryInfo.id!.isEmpty ? 0 : 30
    }
    
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

