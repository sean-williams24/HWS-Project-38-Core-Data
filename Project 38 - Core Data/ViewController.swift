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
    var commits = [Commit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "Project 38 - Core Data")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print(error)
            }
        }
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
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
                self.saveConext()
                self.loadSavedData()
            }
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
    
    func loadSavedData() {
        let request = Commit.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            commits = try container.viewContext.fetch(request)
            print("Fetched \(commits.count) commits")
            tableView.reloadData()
        } catch {
            print("Error fetching commits")
        }
    }


    //MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)

        let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = commit.date.description

        return cell
    }
}


