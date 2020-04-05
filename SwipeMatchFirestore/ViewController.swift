//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/4/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setupDummyCards()
    }

    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        let overallStackview = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonStackView])
        overallStackview.axis = .vertical
        
        view.addSubview(overallStackview)
        overallStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackview.isLayoutMarginsRelativeArrangement = true
        overallStackview.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackview.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupDummyCards() {
        print("Setting up dummy cards")
        let cardView = CardView()
        cardsDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
}

