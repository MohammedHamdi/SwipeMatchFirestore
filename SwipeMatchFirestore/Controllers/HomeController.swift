//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/4/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
        User(name: "Corsair", age: 2, profession: "Gaming PC", imageNames: ["pc1", "pc2", "pc3"]),
        User(name: "Main Gear", age: 1, profession: "Editing PC", imageNames: ["maingearPC", "maingearPC2"]),
        Advertiser(title: "GTX 2080Ti", brandName: "Nvidia", posterPhotoName: "2080ti")
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map({return $0.toCardViewModel()})
        return viewModels
    }()
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonStackView = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
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
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView()
            cardView.cardViewModel = cardViewModel
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    @objc func handleSettings() {
        print("Show registration page")
        let registrationController = RegistrationController()
        registrationController.modalPresentationStyle = .fullScreen
        present(registrationController, animated: true)
    }
}

