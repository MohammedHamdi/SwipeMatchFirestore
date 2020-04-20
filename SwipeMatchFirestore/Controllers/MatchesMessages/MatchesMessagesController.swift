//
//  MatchesMessagesController.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/20/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import LBTATools

class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MatchesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            .red,
            .blue,
            .green,
            .purple,
            .orange
        ]
        
        collectionView.backgroundColor = .white
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
}

class MatchCell: LBTAListCell<UIColor> {
    
    let profileImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "pc3"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2099210322, green: 0.209956944, blue: 0.2099131644, alpha: 1), textAlignment: .center, numberOfLines: 2)
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        stack(stack(profileImageView, alignment: .center), usernameLabel)
    }
}
