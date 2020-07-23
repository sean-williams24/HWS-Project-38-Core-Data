//
//  DetailViewController.swift
//  Project 38 - Core Data
//
//  Created by Sean Williams on 20/07/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    
    var detailItem: Commit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let detail = detailItem {
            detailLabel.text = detail.message
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
        }
    }
    

    @objc func showAuthorCommits() {
        
    }

}
