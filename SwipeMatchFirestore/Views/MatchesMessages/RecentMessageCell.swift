//
//  RecentMessageCell.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/25/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import LBTATools

class RecentMessageCell: LBTAListCell<RecentMessage> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "pc2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "USERNAME HERE", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "Some long line of text that should span 2 line", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)
    
    override var item: RecentMessage! {
        didSet {
            usernameLabel.text = item.name
            messageTextLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        userProfileImageView.layer.cornerRadius = 94 / 2
        
        hstack(userProfileImageView.withWidth(94).withHeight(94),
               stack(usernameLabel, messageTextLabel, spacing: 2),
            spacing: 20, alignment: .center).padLeft(20).padRight(20)
        
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
}
