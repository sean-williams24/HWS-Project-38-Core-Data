//
//  Commit+CoreDataProperties.swift
//  Project 38 - Core Data
//
//  Created by Sean Williams on 22/07/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//
//

import Foundation
import CoreData


extension Commit {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Commit> {
        return NSFetchRequest<Commit>(entityName: "Commit")
    }

    @NSManaged public var date: Date
    @NSManaged public var message: String
    @NSManaged public var sha: String
    @NSManaged public var url: String

}
