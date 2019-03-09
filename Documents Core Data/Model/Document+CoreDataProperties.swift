//
//  Document+CoreDataProperties.swift
//  Documents Core Data
//
//  Created by Dylan Mouser on 2/22/19.
//  Copyright © 2019 Dylan Mouser. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var name: String?
    @NSManaged public var size: Int64
    @NSManaged public var rawmodificationdate: NSDate?
    @NSManaged public var content: String?

}
