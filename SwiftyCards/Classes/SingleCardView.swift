//
//  SingleCardView.swift
//  SwiftyCards
//
//  Created by Konstantin Kulakov on 24/06/2019.
//  Copyright © 2019 Konstantin Kulakov. All rights reserved.
//

import UIKit

open class SingleCardView: UIView {
//    @IBOutlet weak var view: UIView!
//    
    public var combinedAnimationOptions: UIView.AnimationOptions = [.allowUserInteraction]
    public var animationDuration: TimeInterval = 0.5
    
    public var heightAnchorConstant: NSLayoutConstraint?
    public var nextCardTopAnchorConstant: NSLayoutConstraint?
    public var topAnchorConstant: NSLayoutConstraint?
    
    public var minHeight: CGFloat = 0
    public var maxHeight: CGFloat = 0
    
    public var mutexAnimation: Bool = false
    
    public var collapseSpace:CGFloat = 25
    public var openCardCollapseSpace:CGFloat = 20
    
    open func cardDidOpen() {
        
    }
    
    open func cardDidHide() {
        
    }
    
    public func collapse(completionHandler: @escaping(() -> Void), updateHandler: @escaping(() -> Void)) {
        guard let heightConstraint = heightAnchorConstant else { return }
        if heightConstraint.constant < self.maxHeight {
            self.collapseShow(completionHandler: completionHandler, updateHandler: updateHandler)
        } else {
            self.collapseHide(completionHandler: completionHandler, updateHandler: updateHandler)
        }
    }
    
    public func collapseShow(completionHandler: @escaping(() -> Void), updateHandler: @escaping(() -> Void)) {
        guard let heightConstraint = heightAnchorConstant else { return }
        guard heightConstraint.constant < maxHeight else { return }
        
        guard !mutexAnimation else { return }
        mutexAnimation = true
        completionHandler()
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: combinedAnimationOptions, animations: {
            heightConstraint.constant = self.maxHeight
            self.nextCardTopAnchorConstant?.constant = self.openCardCollapseSpace
            self.topAnchorConstant?.constant = self.openCardCollapseSpace
            
            updateHandler()
            self.layoutIfNeeded()
            
            self.cardDidOpen()
        }, completion: { _ in
            self.mutexAnimation = false
        })
    }
    
    
    public func collapseHide(completionHandler: @escaping(() -> Void), updateHandler: @escaping(() -> Void)) {
        guard let heightConstraint = heightAnchorConstant else { return }
        guard heightConstraint.constant >= minHeight else { return }
        
        guard !mutexAnimation else { return }
        mutexAnimation = true
        //completionHandler()
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: combinedAnimationOptions, animations: {
            heightConstraint.constant = self.minHeight
            self.nextCardTopAnchorConstant?.constant = -self.collapseSpace
            self.topAnchorConstant?.constant = -self.collapseSpace
            
            updateHandler()
            self.layoutIfNeeded()
            
            self.cardDidHide()
        }, completion: { _ in
            self.mutexAnimation = false
        })
    }
}

extension SingleCardView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        guard let action = self.tapGestureRecognizerAction else { return }
        
        action?()
    }
    
}
