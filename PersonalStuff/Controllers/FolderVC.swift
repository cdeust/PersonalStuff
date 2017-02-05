//
//  FolderVC.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 04/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

class FolderVC: UIViewController {
    @IBOutlet weak var back: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var numberOfFolder: Array<String>!
}

extension FolderVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberOfFolder = Array<String>()
        self.numberOfFolder.append("Notes")
        self.numberOfFolder.append("Images")
        self.numberOfFolder.append("Videos")
        self.numberOfFolder.append("Messages")
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension FolderVC {
    @IBAction func backPressed() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.popViewController(animated: true)
    }
}
