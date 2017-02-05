//
//  Notes.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 05/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import CoreData

public class Notes: NSManagedObject {
    public class func createNote(uid: String, title: String, text: String, managedObjectContext: NSManagedObjectContext) {
        let managedObject: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: managedObjectContext)
        managedObject.setValue(title, forKey: "note_title")
        managedObject.setValue(text, forKey: "note_text")
        managedObject.setValue(uid, forKey: "note_uid")
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    public class func updateNote(uid: String, title: String, text: String, managedObjectContext: NSManagedObjectContext, managedObject: NSManagedObject) {
        managedObject.setValue(title, forKey: "note_title")
        managedObject.setValue(text, forKey: "note_text")
        managedObject.setValue(uid, forKey: "note_uid")
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    public class func deleteNote(managedObjectContext: NSManagedObjectContext, managedObject: NSManagedObject) {
        managedObjectContext.delete(managedObject)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print ("Delete failed: \(error.localizedDescription)")
        }
    }
    
    public class func fetchNote(title: String, managedObjectContext: NSManagedObjectContext) -> NSArray {
        
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        let predicate = NSPredicate(format: "title == \"\(title)\"")
        fetchRequest.predicate = predicate
        
        var results = NSArray()
        do {
            results = try managedObjectContext.fetch(fetchRequest) as NSArray
            return results
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return results
    }
}
