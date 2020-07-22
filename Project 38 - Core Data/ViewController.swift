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
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
    }
    
    @objc func fetchCommits() {
        if let stringData = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            let jsonCommits = JSON(parseJSON: stringData)
            
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Recieved \(jsonCommitArray.count) new commits.")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    let commit = Commit(context: self.container.viewContext)
                    self.configure(commit: commit, usingJson: jsonCommit)
                }
            }
            saveConext()
        }
    }
    
    func configure(commit: Commit, usingJson json: JSON) {
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
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


