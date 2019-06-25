//
//  ViewController.swift
//  SwiftyCards
//
//  Created by Konstantin Kulakov on 24/06/2019.
//  Copyright © 2019 Konstantin Kulakov. All rights reserved.
//

import UIKit
import SwiftyCards

class ViewController: UIViewController {
    
    @IBOutlet weak var swifyCardsContainer: SwiftyCards!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swifyCardsContainer.autoCollapse = true

        swifyCardsContainer.append(card: LabelAndTextCard())
        swifyCardsContainer.append(card: JustTextCard())
        swifyCardsContainer.append(card: LabelAndTextCard())
        swifyCardsContainer.append(card: JustTextCard())
        swifyCardsContainer.append(card: LabelAndTextCard())
        swifyCardsContainer.append(card: JustTextCard())
        swifyCardsContainer.append(card: LabelAndTextCard())
        
        
        let bankCardsImages = [
            "sberbank",
            "alfabank",
            "tinkof",
            "sberbank2",
            "alfabank",
            "tinkof2",
            "alfabank2"
        ]
        
        for cardImageName in bankCardsImages {
            guard let imageCard = UIImage(named: cardImageName) else { return }
            let bankCard = BankCardExampleCard()
            bankCard.cardImage.image = imageCard
            swifyCardsContainer.append(card: bankCard)
        }
    }
}
