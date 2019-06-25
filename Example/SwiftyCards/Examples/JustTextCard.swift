//
//  JustTextCard.swift
//  SwiftyCards
//
//  Created by Konstantin Kulakov on 24/06/2019.
//  Copyright © 2019 Konstantin Kulakov. All rights reserved.
//

import UIKit
import SwiftyCards

class JustTextCard: SingleCardView {
    
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override func cardDidHide() {
        // DISABLE USER INTERACTION
        self.view.isUserInteractionEnabled = false
    }
    
    override func cardDidOpen() {
        // ENABLE USER INTERACTION
        self.view.isUserInteractionEnabled = true
    }
    
    private func nibSetup() {
        Bundle.main.loadNibNamed("JustTextCard", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // SETUP SIZES
        self.maxHeight = 400
        self.minHeight = 250
        
        // DISABLE USER INTERACTION
        self.view.isUserInteractionEnabled = false
    }
}
