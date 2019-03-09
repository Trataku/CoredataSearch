//
//  Document+CoreDataClass.swift
//  Documents Core Data
//
//  Created by Dylan Mouser on 2/22/19.
//  Copyright © 2019 Dylan Mouser. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    var modificationDate: Date? {
        get{
            return rawmodificationdate as Date?
        }
        set{
            rawmodificationdate = newValue as NSDate?
        }
    }
    
    convenience init?(name: String?, size: Int64, date: Date?, content: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{
            return nil
        }
        
        self.init(entity: Document.entity(), insertInto: managedContext)
        
        self.name = name
        self.modificationDate = date
        self.content = content
        self.size = size
    }
}
