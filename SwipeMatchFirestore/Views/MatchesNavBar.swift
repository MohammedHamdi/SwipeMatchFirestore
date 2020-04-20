//
//  MatchesNavBar.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/20/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import LBTATools

class MatchesNavBar: UIView {

    let backButton = UIButton(image: #imageLiteral(resourceName: "app_icon"), tintColor: .init(white: 0, alpha: 0.15))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 0.949775517, green: 0.2833624482, blue: 0.5616319776, alpha: 1)
        let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.949775517, green: 0.2833624482, blue: 0.5616319776, alpha: 1), textAlignment: .center)
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor:.gray, textAlignment: .center)
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        stack(iconImageView.withHeight(44),
            hstack(messagesLabel, feedLabel, distribution: .fillEqually)).padTop(10)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
