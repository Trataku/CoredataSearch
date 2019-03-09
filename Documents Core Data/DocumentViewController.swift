//
//  DocumentViewController.swift
//  Documents Core Data
//
//  Created by Dylan Mouser on 2/22/19.
//  Copyright © 2019 Dylan Mouser. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var documentTextView: UITextView!
    
    var existingDocument: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fix this
        nameTextField.text = existingDocument?.name
        documentTextView.text = existingDocument?.content
        title = existingDocument?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nameChanged(_ sender: Any) {
        title = nameTextField.text
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        guard let content = documentTextView.text else {
            return
        }
        
        //get current date
        let currentTime = Date()
        //find size of text file
        let sizeOfText = content.utf8.count
        
        var document: Document?
        
        if let existingDocument = existingDocument{
            existingDocument.name = name
            existingDocument.content = content
            existingDocument.modificationDate = currentTime
            existingDocument.size = Int64(sizeOfText)
            
            document = existingDocument
        }else{
            document = Document(name: name, size: Int64(sizeOfText), date: currentTime, content: content)
        }
        
        if let document = document{
            do{
                let managedContext = document.managedObjectContext
                
                try managedContext?.save()
                
                navigationController?.popViewController(animated: true)
            }catch{
                print("Context could not be saved")
            }
        }
        
        //Documents.save(name: name, content: documentTextView.text)
    }

}
