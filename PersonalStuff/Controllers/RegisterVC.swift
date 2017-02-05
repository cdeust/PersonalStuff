//
//  RegisterVC.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 04/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
}

extension RegisterVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension RegisterVC {
    @IBAction func createPressed() {
        guard let navigationController = self.navigationController else { return }
        
        let storyboard = UIStoryboard(name: "Folder", bundle: nil)
        let folder = storyboard.instantiateViewController(withIdentifier: "Folder")
        navigationController.pushViewController(folder, animated: true)
    }
}

