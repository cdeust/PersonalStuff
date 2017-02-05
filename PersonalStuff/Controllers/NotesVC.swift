//
//  NotesVC.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 04/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

class NotesVC: UIViewController {
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    var viewModel: NotesVM!
}

extension NotesVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension NotesVC {
    func saveNote(sender: UIButton) {
        if let noteTitle = self.noteTitleTextField.text, let noteText = self.noteTextView.text {
            self.viewModel = NotesVM.init(title: noteTitle, text: noteText, delegate: self)
            self.viewModel.saveNote()
        }
    }
}
