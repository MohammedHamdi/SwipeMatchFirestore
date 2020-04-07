//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/6/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
}
