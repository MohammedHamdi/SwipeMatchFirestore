//
//  Match.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/23/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Foundation

struct Match {
    let name, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
