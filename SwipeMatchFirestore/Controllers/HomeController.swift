//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/4/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
//    var cardViewModels = [CardViewModel]()
    
    fileprivate var user: User?
    fileprivate let hud = JGProgressHUD(style: .dark)
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
//        setupFirestoreUserCards()
//        fetchUsersFromFirestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    //MARK:- Login Delegate functions
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }

    // MARK:- Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let overallStackview = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackview.axis = .vertical
        
        view.addSubview(overallStackview)
        overallStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        overallStackview.isLayoutMarginsRelativeArrangement = true
        overallStackview.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackview.bringSubviewToFront(cardsDeckView)
    }
    
//    fileprivate func setupFirestoreUserCards() {
//        cardViewModels.forEach { (cardViewModel) in
//            let cardView = CardView()
//            cardView.cardViewModel = cardViewModel
//            
//            cardsDeckView.addSubview(cardView)
//            cardView.fillSuperview()
//        }
//    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    //MARK:- Firebase
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch current user:", error)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFirestore()
        }
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            
            if let error = error {
                print("Failed to fetch users:", error)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didTapMoreInfo() {
        let userDetailsController = UserDetailsController()
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.layer.removeAllAnimations()})
        fetchUsersFromFirestore()
    }
}

