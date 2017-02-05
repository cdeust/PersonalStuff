//
//  Folder+TableViewDelegate.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 04/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

extension FolderVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Notes", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Notes")
            navigationController.pushViewController(viewController, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Images", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Images")
            navigationController.pushViewController(viewController, animated: true)
        case 2:
            let storyboard = UIStoryboard(name: "Videos", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Videos")
            navigationController.pushViewController(viewController, animated: true)
        case 3:
            let storyboard = UIStoryboard(name: "Messages", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Messages")
            navigationController.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
}
