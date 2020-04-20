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
        
        navigationController?.navigationBar.isHidden = true
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
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
            
            self.fetchSwipes()
            
//            self.fetchUsersFromFirestore()
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch swipes info for currently logged in user:", error)
                return
            }
            
            print("Swipes:", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        topCardView = nil
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            
            if let error = error {
                print("Failed to fetch users:", error)
                return
            }
            
            // Linked List
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwippedBefore = /*self.swipes[user.uid!] == nil*/true
                if  isNotCurrentUser && hasNotSwippedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        print("Home controller:", cardViewModel.attributedString)
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
    
    @objc fileprivate func handleRefresh() {
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
//        fetchUsersFromFirestore()
        fetchSwipes()
    }
    
    var topCardView: CardView?
    
    @objc func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch swipe document:", error)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data:", error)
                        return
                    }
                    print("Successfully updated swipe")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data:", error)
                        return
                    }
                    print("Successfully saved swipe")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        print("Detecting match")
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch document for card user:", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
//            print(data)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                print("Has matched")
                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    func didRemoveCard(cardView: CardView) {
        topCardView?.removeFromSuperview()
        topCardView = self.topCardView?.nextCardView
    }
    
    @objc fileprivate func handleMessages() {
        let vc = MatchesMessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
    }
}

