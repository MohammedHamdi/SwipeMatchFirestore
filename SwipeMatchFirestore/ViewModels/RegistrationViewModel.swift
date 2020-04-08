//
//  RegistrationViewmodel.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/8/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var fullName: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    // Reactive programming
    var isFormValidObserver: ((Bool) -> ())?
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
