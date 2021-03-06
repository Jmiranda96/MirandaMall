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
    
    var errorView = UIView()
    
    var query = String()
    var categoryInfo = MLServices.MLCategoryDetails()
    var isLoading = false
    var loadMoreItems = true
    
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
        self.getItems()
        
        //tap gesture implemented to dismiss keyboard
        self.dismissKeyboardOnTap()
        
        // Notification subscription to get keyboard height and adjust table bounds
        notificationSetup()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemDetailsViewController {
            
            if let senderInfo = sender as? [String: String] {
                destination.id = senderInfo["id"]!
            }
        }
    }
    
    func getItems(newPage: Bool = false) {
        loadMoreItems = true
        self.model.getItems(byCategory: categoryInfo.id!, bySearch: query, newPage: newPage)
    }
    
    func setItems() {
        self.errorView.removeFromSuperview()
        self.view.bringSubviewToFront(itemListTableView)
        self.itemListTableView.reloadData()
        self.isLoading = false
    }
    
    func noResults(){
        self.showErrorView(icon: "notFoundIcon", msg: "No se encontraron resultados :(")
    }
    
    func errorInRequest(){
        self.showErrorView(icon: "errorIcon", msg: "Hubo un error inesperado. \n Intenta de nuevo :)")
    }
    
    func stopLoader(){
        loadMoreItems = false
        self.itemListTableView.reloadData()
    }
    
    func showErrorView(icon: String, msg: String) {
        errorView = UIView()
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
        self.query = searchBar.text ?? ""
        self.getItems()
        self.searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.searchTextField.resignFirstResponder()
    }
    
}

// MARK: - UICollectionViewDelegate

extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return loadMoreItems ? 2 : 1
    }
    
    // Check if the categoryInfo is provided to display header in section with the name of the category searched
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard section == 0 else { return nil }
        
        return categoryInfo.id!.isEmpty ? "" : categoryInfo.name
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard section == 0 else { return 0 }
        
        return categoryInfo.id!.isEmpty ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard indexPath.section == 0 else { return 50 }
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard section == 0 else { return 1 }
        
        return self.model.itemList.count > 0 ? self.model.itemList.count : 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.section == 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingTableViewCell
            cell.loader.startAnimating()
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath) as! ItemListTableViewCell

        guard self.model.itemList.count > 0 else {
            return cell
        }
        
        let info = self.model.itemList[indexPath.row]
        
        cell.itemInfo = info
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: ["id": self.model.itemList[indexPath.row].id])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard loadMoreItems else {return}
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 2) && !isLoading {
            self.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.getItems(newPage: true)
            }
        }
    }
    
    
}

