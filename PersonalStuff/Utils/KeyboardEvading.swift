//
//  KeyboardEvading.swift
//  PersonalStuff
//
//  Created by Clément DEUST on 08/02/2017.
//  Copyright © 2017 cdeust. All rights reserved.
//

import Foundation
import UIKit

@objc public enum KeyboardEvadingMode: Int {
    case maximum
    case minimum
    case minimumDelayed
}

@objc public class KeyboardEvading: NSObject {
    
    private static var minimumAnimationDuration: CGFloat = 0.0
    private static var lastNotification: Foundation.Notification!
    private static var updatedConstraints = [NSLayoutConstraint]()
    private static var updatedConstraintConstants = [CGFloat]()
    private static var evadingViewUsesAutoLayout = false
    private static var triggerViews = [UIView]()
    private static var _evadingView: UIView?
    
    private(set) static var isKeyboardVisible = false
    
    public static var buffer: CGFloat = 0.0
    public static var paddingForCurrentEvadingView: CGFloat = 0.0
    public static var keyboardEvadingMode = KeyboardEvadingMode.minimum
    
    public static var padding: CGFloat = 0.0 {
        willSet {
            if self.paddingForCurrentEvadingView == newValue {
                self.paddingForCurrentEvadingView = newValue
            }
        }
    }
    
    public static var evadingBlock: ((Bool, CGFloat, CGFloat, UIViewAnimationOptions)->Void)? {
        willSet {
            self.initialise()
        }
        didSet {
            if self.triggerViews.count == 0 && self.evadingBlock != nil {
                self.triggerViews.append(UIView())
            }
            self.deinitialise()
        }
    }
    
    public static var evadingView: UIView? {
        get {
            return _evadingView
        }
        set {
            self.setEvadingView(newValue, withOptionalTriggerView: newValue)
        }
    }
    
    class func didChange(_ notification: Foundation.Notification) {
        var isKeyBoardShowing = false
        var keyboardHeightDiff:CGFloat = 0.0
        var animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
        
        let isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
        let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardFrameBegin = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let screenSize = UIScreen.main.bounds.size
        let animationCurve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! Int
        let animationOptions = animationCurve << 16
        
        if keyboardFrameBegin.size.height > 0 {
            keyboardHeightDiff = keyboardFrameBegin.size.height - keyboardFrame.size.height
        }
        
        if keyboardFrame.size.height == 0 && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            if isPortrait && keyboardFrameBegin.origin.y + keyboardFrameBegin.size.height == screenSize.height {
                return
            } else if !isPortrait && keyboardFrameBegin.origin.x + keyboardFrameBegin.size.width == screenSize.width {
                return
            }
        }
        
        if !keyboardFrame.isEmpty && (keyboardFrame.origin.y == 0 || (keyboardFrame.origin.y + keyboardFrame.size.height == screenSize.height)) {
            isKeyBoardShowing = true
            self.lastNotification = notification
        }
        
        if animationDuration == 0 {
            animationDuration = 0.1
        }
        
        if isKeyBoardShowing {
            for triggerView in self.triggerViews {
                
                var diff: CGFloat = 0.0
                
                if keyboardHeightDiff != 0 {
                    diff = keyboardHeightDiff
                } else {
                    let originInWindow = triggerView.convert(triggerView.bounds.origin, to: nil)
                    
                    switch UIApplication.shared.statusBarOrientation {
                    case .portrait, .landscapeLeft:
                        diff = keyboardFrame.origin.y
                        diff = diff - (originInWindow.y + triggerView.frame.size.height)
                        break
                    case .portraitUpsideDown, .landscapeRight:
                        diff = screenSize.height - keyboardFrame.size.height
                        diff = diff - (originInWindow.y + triggerView.frame.size.height)
                        break
                    default:
                        break
                    }
                    
                }
                if diff < self.buffer || keyboardHeightDiff != 0 {
                    var displacement = (isPortrait ? -keyboardFrame.size.height : -keyboardFrame.size.width)
                    var delay: CGFloat = 0.0
                    
                    switch self.keyboardEvadingMode {
                    case .maximum:
                        self.minimumAnimationDuration = animationDuration
                        break
                    case .minimumDelayed:
                        let minimumDisplacement = max(displacement, diff)
                        self.minimumAnimationDuration = animationDuration * (minimumDisplacement / displacement)
                        displacement = minimumDisplacement - self.paddingForCurrentEvadingView
                        delay = (animationDuration - self.minimumAnimationDuration)
                        animationDuration = self.minimumAnimationDuration
                        break
                    default:
                        let minimumDisplacement = max(displacement, diff)
                        displacement = minimumDisplacement - (keyboardHeightDiff == 0 ? self.paddingForCurrentEvadingView : 0)
                        
                    }
                    
                    if self.evadingView != nil && self.evadingView!.superview != nil {
                        if self.evadingViewUsesAutoLayout {
                            var hasFoundFirstConstraint = false
                            
                            for constraint: NSLayoutConstraint in self.evadingView!.superview!.constraints {
                                if let secondItem = constraint.secondItem as? NSObject, secondItem == self.evadingView! && (constraint.secondAttribute == .centerY || constraint.secondAttribute == .top || constraint.secondAttribute == .bottom) {
                                    if !self.updatedConstraints.contains(constraint) {
                                        self.updatedConstraints.append(constraint)
                                        self.updatedConstraintConstants.append(constraint.constant)
                                    }
                                    constraint.constant -= displacement
                                    hasFoundFirstConstraint = true
                                }
                            }
                            
                            if !hasFoundFirstConstraint {
                                for constraint: NSLayoutConstraint in self.evadingView!.superview!.constraints {
                                    if constraint.firstItem as! NSObject == self.evadingView! && (constraint.firstAttribute == .centerY || constraint.firstAttribute == .top || constraint.firstAttribute == .bottom) {
                                        if !self.updatedConstraints.contains(constraint) {
                                            self.updatedConstraints.append(constraint)
                                            self.updatedConstraintConstants.append(constraint.constant)
                                        }
                                        constraint.constant += displacement
                                    }
                                }
                            }
                            self.evadingView!.superview!.setNeedsUpdateConstraints()
                        }
                        
                        UIView.animate(withDuration: TimeInterval(animationDuration), delay: TimeInterval(delay), options: UIViewAnimationOptions(rawValue: UInt(animationOptions)), animations: {() -> Void in
                            if self.evadingViewUsesAutoLayout {
                                self.evadingView!.superview!.layoutIfNeeded()
                            } else {
                                var transform = self.evadingView!.transform
                                transform = transform.translatedBy(x: 0, y: displacement)
                                self.evadingView!.transform = transform
                            }
                        }, completion: { _ in })
                    }
                }
                if self.evadingBlock != nil {
                    self.evadingBlock!(isKeyBoardShowing, animationDuration, keyboardFrame.size.height, UIViewAnimationOptions(rawValue: UInt(animationOptions)))
                }
            }
            
        } else if self.isKeyboardVisible {
            switch self.keyboardEvadingMode {
            case .maximum:
                break
            case .minimumDelayed:
                animationDuration = self.minimumAnimationDuration
                break
            default:
                break
            }
            
            if self.evadingView != nil && self.evadingView!.superview != nil {
                if self.evadingViewUsesAutoLayout {
                    for (index, updatedConstraint) in self.updatedConstraints.enumerated() {
                        let updatedConstraintConstant = self.updatedConstraintConstants[index]
                        updatedConstraint.constant = updatedConstraintConstant
                    }
                    self.evadingView!.superview!.setNeedsUpdateConstraints()
                }
                UIView.animate(withDuration: TimeInterval(animationDuration + CGFloat(0.075)), delay: 0, options: UIViewAnimationOptions(rawValue: UInt(animationOptions)), animations: {() -> Void in
                    if self.evadingViewUsesAutoLayout {
                        self.evadingView!.superview!.layoutIfNeeded()
                    } else {
                        self.evadingView!.transform = CGAffineTransform.identity
                    }
                }, completion: {(_ finished: Bool) -> Void in
                    self.updatedConstraints.removeAll()
                    self.updatedConstraintConstants.removeAll()
                })
            }
            if self.evadingBlock != nil {
                self.evadingBlock!(isKeyBoardShowing, animationDuration + 0.075, 0, UIViewAnimationOptions(rawValue: UInt(animationOptions)))
            }
        }
        self.isKeyboardVisible = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(screenSize.width), height: CGFloat(screenSize.height)).intersects(keyboardFrame)
        
        
    }
    
    public class func setEvadingView(_ evadingView: UIView?, withTriggerView triggerView: UIView) {
        self.setEvadingView(evadingView, withOptionalTriggerView: triggerView)
    }
    
    private class func setEvadingView(_ evadingView: UIView?, withOptionalTriggerView triggerView: UIView?) {
        self.initialise()
        
        self._evadingView = avoidingView
        self.evadingViewUsesAutoLayout = (evadingView != nil && evadingView!.superview != nil) ? evadingView!.superview!.constraints.count > 0 : false
        
        self.triggerViews.removeAll()
        if triggerView != nil {
            self.triggerViews.append(triggerView!)
        }
        
        self.paddingForCurrentAvoidingView = self.padding
        self.evadingBlock = nil
        if self.isKeyboardVisible && avoidingView != nil {
            self.didChange(self.lastNotification)
        }
        self.deinitialise()
    }
    
    public class func addTriggerView(_ triggerView: UIView) {
        self.triggerViews.append(triggerView)
    }
    
    public class func removeTriggerView(_ triggerView: UIView) {
        if let index = triggerViews.index(of: triggerView) as Int! {
            self.triggerViews.remove(at: index)
        }
    }
    
    public class func removeAll() {
        self.triggerViews.removeAll()
        self.evadingView = nil
        self.evadingBlock = nil
    }
    
    private class func initialise() {
        if self.evadingBlock == nil && self.evadingView == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAvoiding.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAvoiding.didChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        }
    }
    private class func deinitialise() {
        if self.evadingBlock == nil && self.evadingView == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    class func isLandscape() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
    }
    
    class func applicationDidEnterBackground(_ notification: Foundation.Notification) {
        UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
    }
}
