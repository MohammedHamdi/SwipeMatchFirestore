//
//  UserDetailsController.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/14/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController, UIScrollViewDelegate {

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "thermaltake"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text placeholder"
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }

    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
}
