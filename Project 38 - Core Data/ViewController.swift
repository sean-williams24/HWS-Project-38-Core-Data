//
//  ViewController.swift
//  Project 38 - Core Data
//
//  Created by Sean Williams on 20/07/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UITableViewController {
    
    var container: NSPersistentContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "Project 38 - Core Data")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func saveConext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }


}


