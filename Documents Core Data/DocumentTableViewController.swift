//
//  DocumentTableViewController.swift
//  Documents Core Data
//
//  Created by Dylan Mouser on 2/22/19.
//  Copyright © 2019 Dylan Mouser. All rights reserved.
//

import UIKit
import CoreData

class DocumentTableViewController: UITableViewController {
    @IBOutlet var documentsTableView: UITableView!
    
    var documents = [Document]()
    var filteredDocuments = [Document]()
    let dateFormatter = DateFormatter()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Documents"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        
        do {
            documents = try managedContext.fetch(fetchRequest)
            
            documentsTableView.reloadData()
        }catch{
            print("Fetch could not be performed")
        }
        //documents = Documents.get()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDocuments.count
        }
        
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell {
            let document: Document
            
            if isFiltering(){
                document = filteredDocuments[indexPath.row]
            }else{
                document = documents[indexPath.row]
            }
            
            cell.nameLabel.text = document.name
            cell.sizeLabel.text = String(document.size) + " bytes"
            //cell.modificationDateLabel.text = dateFormatter.string(from: document.modificationDate)
            if let date = document.modificationDate{
                cell.modificationDateLabel.text = dateFormatter.string(from: date)
            }
        }
        
        return cell
    }
    
    func deleteDocument(at indexPath: IndexPath){
        let document = documents[indexPath.row]
        
        if let managedContext = document.managedObjectContext{
            managedContext.delete(document)
            
            do{
                try managedContext.save()
                
                self.documents.remove(at: indexPath.row)
                self.documentsTableView.deleteRows(at: [indexPath], with: .fade)
            }catch{
                print("Delete Failed")
                self.documentsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if !isFiltering(){
                deleteDocument(at: indexPath)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentViewController,
            let selectedRow = self.documentsTableView.indexPathForSelectedRow?.row else{
                return
        }
        
        if isFiltering(){
            destination.existingDocument = filteredDocuments[selectedRow]
        }
        else{
            destination.existingDocument = documents[selectedRow]
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        let searchPredicate = NSPredicate(format: "name contains[c] %@ OR content contains[c] %@", argumentArray: [searchText, searchText])
        
        filteredDocuments = documents.filter { searchPredicate.evaluate(with: $0) }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension DocumentTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
