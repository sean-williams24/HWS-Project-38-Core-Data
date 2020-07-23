//
//  Commit+CoreDataClass.swift
//  Project 38 - Core Data
//
//  Created by Sean Williams on 22/07/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called!")
    }
}
