//
//  SwiftyCards.swift
//  SwiftyCards
//
//  Created by Konstantin Kulakov on 24/06/2019.
//  Copyright © 2019 Konstantin Kulakov. All rights reserved.
//

import UIKit

open class SwiftyCards: UIView {
    public var collapseSpace:CGFloat = 25
    public var openCardCollapseSpace:CGFloat = 20
    public var cornerRadiusCard: CGFloat = 15
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollViewInsideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var lastCard: SingleCardView? = nil
    private var lastCardBottomConstraint: NSLayoutConstraint? = nil
    
    public var cards: [SingleCardView] = []
    
    public var autoCollapse: Bool = false {
        didSet {
            collapseHideAll()
        }
    }

    public func collapseHideAll() {
        cards.forEach {
            $0.collapseHide(completionHandler: {}) {
                self.layoutIfNeeded()
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(scrollView)
        scrollView.frame = self.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(scrollViewInsideView)
        scrollViewInsideView.frame = self.bounds
        scrollViewInsideView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollViewInsideView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        scrollViewInsideView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        scrollViewInsideView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        scrollViewInsideView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        scrollViewInsideView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0).isActive = true
        let heightConstraint = scrollViewInsideView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }
    
    public func append(card: SingleCardView, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        scrollViewInsideView.addSubview(card)
        
        if minHeight != nil {
            card.minHeight = minHeight ?? 0
        }
        if maxHeight != nil {
            card.maxHeight = maxHeight ?? 0
        }
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        if lastCard != nil {
            lastCardBottomConstraint?.isActive = false
            card.topAnchorConstant = card.topAnchor.constraint(equalTo: lastCard!.bottomAnchor, constant: -collapseSpace)
            self.cards.last?.nextCardTopAnchorConstant = card.topAnchorConstant
            card.topAnchorConstant?.isActive = true
        } else {
            card.topAnchor.constraint(equalTo: scrollViewInsideView.topAnchor, constant: 0).isActive = true
        }
        
        card.leadingAnchor.constraint(equalTo: scrollViewInsideView.leadingAnchor, constant: 0).isActive = true
        card.trailingAnchor.constraint(equalTo: scrollViewInsideView.trailingAnchor, constant: 0).isActive = true
        card.heightAnchorConstant = card.heightAnchor.constraint(equalToConstant: card.minHeight)
        card.heightAnchorConstant?.isActive = true
        
        lastCard = card
        lastCardBottomConstraint = card.bottomAnchor.constraint(equalTo: scrollViewInsideView.bottomAnchor, constant: 0)
        lastCardBottomConstraint?.isActive = true
        
        card.layer.cornerRadius = cornerRadiusCard;
        card.layer.masksToBounds = true;
        
        card.collapseSpace = self.collapseSpace
        card.openCardCollapseSpace = self.openCardCollapseSpace
        
        var currentHeightTop = self.cards.reduce(0) { (result, next) -> CGFloat in
            return result + next.minHeight - collapseSpace
        }
        if cards.count > 0 {
            currentHeightTop += collapseSpace
        }
        
        cards.append(card)

        
        card.addTapGestureRecognizer {
            card.collapse(completionHandler: {
                self.updateAfterCollapse()
                
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: currentHeightTop), animated: true)
                UIView.animate(withDuration: card.animationDuration, animations: {
                    self.scrollView.setContentOffset(
                        CGPoint(x: 0, y: currentHeightTop), animated: false)
                    self.layoutIfNeeded()
                })
            }, updateHandler: self.layoutIfNeeded)
        }
    }
    
    public func updateAfterCollapse() {
        self.layoutIfNeeded()
        
        if self.autoCollapse {
            self.collapseHideAll()
        }
    }
}
