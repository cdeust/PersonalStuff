//
//  KeyboardDismissing.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 08/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

public class KeyboardDismissing: UIView {
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        _ = KeyboardDismissing.resignAnyFirstResponder(self)
    }
    
    public class func resignAnyFirstResponder(_ view: UIView) -> Bool {
        var hasResigned = false
        for subView in view.subviews {
            if subView.isFirstResponder {
                subView.resignFirstResponder()
                hasResigned = true
                if let searchBar = subView as? UISearchBar {
                    searchBar.setShowsCancelButton(false, animated: true)
                }
            } else {
                hasResigned = KeyboardDismissing.resignAnyFirstResponder(subView) || hasResigned
            }
        }
        return hasResigned
    }
}
