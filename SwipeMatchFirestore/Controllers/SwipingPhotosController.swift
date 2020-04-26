//
//  SwipingPhotosController.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/16/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            
            setupBarViews()
        }
    }
    
    fileprivate let barsStackview = UIStackView(arrangedSubviews: [])
    fileprivate let deselectedBarColor = UIColor(white: 0, alpha: 0.1)

    fileprivate let isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBarViews() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2
            barsStackview.addArrangedSubview(barView)
        }
        
        barsStackview.arrangedSubviews.first?.backgroundColor = .white
        barsStackview.spacing = 4
        barsStackview.distribution = .fillEqually
        
        view.addSubview(barsStackview)
        if #available(iOS 13.0, *) {
        } else {
            var paddingTop: CGFloat = 8
            if !isCardViewMode {
                paddingTop += UIApplication.shared.statusBarFrame.height
            }
//            let paddingTop = UIApplication.shared.statusBarFrame.height + 8
            barsStackview.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        }
//        barsStackview.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if #available(iOS 13.0, *) {
            var paddingTop: CGFloat = 8
            let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            if !isCardViewMode {
                paddingTop += statusBarHeight
            }
            barsStackview.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackview.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            barsStackview.arrangedSubviews[index].backgroundColor = .white
        }
        
    }
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        view.backgroundColor = .white
        
        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let currentController = viewControllers!.first!
        if let index = controllers.firstIndex(of: currentController) {
            
            barsStackview.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
            
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false)
                barsStackview.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let previousIndex = max(0, index - 1)
                let previousController = controllers[previousIndex]
                setViewControllers([previousController], direction: .forward, animated: false)
                barsStackview.arrangedSubviews[previousIndex].backgroundColor = .white
            }
        }
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
}
