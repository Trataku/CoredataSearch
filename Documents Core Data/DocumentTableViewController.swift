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
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
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
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell {
            let document = documents[indexPath.row]
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
            deleteDocument(at: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DocumentViewController,
            let selectedRow = self.documentsTableView.indexPathForSelectedRow?.row else{
                return
        }
        
        destination.existingDocument = documents[selectedRow]
    }


}
