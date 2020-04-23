//
//  Message.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/23/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Firebase

struct Message {
    let text, fromId, toId: String
    let timestamp: Timestamp
    let isFromCurrentLoggedUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentLoggedUser = Auth.auth().currentUser?.uid == self.fromId
    }
}
