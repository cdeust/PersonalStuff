//
//  UIFont+HelveticaNeue.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 08/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {
    public class func helveticaNeueRegular(size: CGFloat) {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
    public class func helveticaNeueItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Italic", size: size)!
    }
    
    public class func helveticaNeueBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    public class func helveticaNeueMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    public class func helveticaNeueLight(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)!
    }
    
    public class func helveticaNeueThin(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Thin", size: size)!
    }
    
    public class func helveticaNeueUltraLight(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-UltraLight", size: size)!
    }
}
