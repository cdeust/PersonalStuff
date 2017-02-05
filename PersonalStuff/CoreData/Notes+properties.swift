//
//  Notes+properties.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 05/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import CoreData

extension Notes {
    @NSManaged public var note_title: String?
    @NSManaged public var note_text: String?
    @NSManaged public var note_uid: String?
}
