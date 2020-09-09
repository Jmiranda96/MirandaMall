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
    
    var query = String()
    var categoryInfo = MLServices.MLCategoryDetails()
    
    var model = ItemListModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.itemListTableView.dataSource = self
        self.itemListTableView.delegate = self
        self.model.delegate = self
        
        //Set searchBar text
        self.searchBar.text = query
        self.searchBar.placeholder = "Que quieres vitrinear?"
        
        //the items list is fetched by the category and/or search text
        self.model.getItems(byCategory: categoryInfo.id!, bySearch: query)
        
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
        self.view.bringSubviewToFront(itemListTableView)
        self.itemListTableView.reloadData()
    }
    
    func noResults(){
        self.showErrorView(icon: "notFoundIcon", msg: "No se encontraron resultados :(")
    }
    
    func errorInRequest(){
        self.showErrorView(icon: "errorIcon", msg: "Hubo un error inesperado. \n Intenta de nuevo :)")
    }
    
    func showErrorView(icon: String, msg: String) {
        let errorView = UIView()
        errorView.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        errorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        errorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let errorImage = UIImageView()
        errorImage.image = UIImage(named: icon)
        errorView.addSubview(errorImage)
        errorImage.translatesAutoresizingMaskIntoConstraints = false
        errorImage.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        errorImage.centerYAnchor.constraint(equalTo: errorView.centerYAnchor, constant: -50).isActive = true
        
        let errorMsg = UILabel()
        errorMsg.font = UIFont.boldSystemFont(ofSize: 24)
        errorMsg.text = msg
        errorMsg.textAlignment = .center
        errorMsg.numberOfLines = 0
        errorView.addSubview(errorMsg)
        errorMsg.translatesAutoresizingMaskIntoConstraints = false
        errorMsg.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 20).isActive = true
        errorMsg.centerXAnchor.constraint(equalTo: errorView.centerXAnchor).isActive = true
        
        self.view.bringSubviewToFront(errorView)
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
            self.tableBottonConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom
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
        self.model.getItems(byCategory: categoryInfo.id!, bySearch: searchBar.text ?? "")
        self.searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.searchTextField.resignFirstResponder()
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

