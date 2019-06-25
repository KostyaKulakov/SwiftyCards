//
//  BankCardExampleCard.swift
//  SwiftyCards
//
//  Created by Konstantin Kulakov on 24/06/2019.
//  Copyright © 2019 Konstantin Kulakov. All rights reserved.
//

import UIKit
import SwiftyCards

class BankCardExampleCard: SingleCardView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        Bundle.main.loadNibNamed("BankCardExampleCard", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // SETUP SIZES
        self.maxHeight = 230
        self.minHeight = 100
    }
}
