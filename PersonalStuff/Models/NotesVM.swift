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
    private var _noteTitle: String
    private var _noteText: String
    private var _delegate: NoteDelegate
    
    var noteTitle: String {
        get {
            return _noteTitle;
        }
        set {
            _noteTitle = newValue
        }
    }
    
    var noteText: String {
        get {
            return _noteText
        }
        set {
            _noteText = newValue
        }
    }
    
    var delegate: NoteDelegate {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    init(title: String, text: String, delegate: NoteDelegate) {
        self._noteTitle = title
        self._noteText = text
        self._delegate = delegate
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
