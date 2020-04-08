//
//  Bindable.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/8/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
