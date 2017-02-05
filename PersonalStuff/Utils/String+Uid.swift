//
//  String+Uid.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 05/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation


extension String {
    public func uid() -> String {
        let uid = UUID().uuidString
        return uid
    }
}
