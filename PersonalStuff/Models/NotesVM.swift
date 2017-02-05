//
//  NotesVM.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 05/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

protocol NoteDelegate {
    func didSuccessfullyCreate()
    func didFailedToCreate()
}

class NotesVM: NSObject {
    var noteTitle: String
    var noteText: String
    var delegate: NoteDelegate
    
    init(title: String, text: String, delegate: NoteDelegate) {
        self.noteTitle = title
        self.noteText = text
        self.delegate = delegate
    }
}

extension NotesVM {
    func saveNote() {
        let managedObjectContext = CoreDataStack.sharedStack.persistentContainer.viewContext
        Notes.createNote(uid: String().uid(), title: self.noteTitle, text: self.noteText, managedObjectContext: managedObjectContext)
        
        let result = Notes.fetchNote(title: self.noteTitle, managedObjectContext: managedObjectContext)
        
        if result.count > 0 {
            self.delegate.didSuccessfullyCreate()
        } else {
            self.delegate.didFailedToCreate()
        }
    }
}
