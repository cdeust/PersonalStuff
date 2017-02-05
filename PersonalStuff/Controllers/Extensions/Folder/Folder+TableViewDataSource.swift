//
//  Folder+TableViewDataSource.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 04/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

extension FolderVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "defaultCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = self.numberOfFolder[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfFolder.count
    }
}
