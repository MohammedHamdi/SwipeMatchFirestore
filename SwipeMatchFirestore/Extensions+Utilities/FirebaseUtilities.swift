//
//  FirebaseUtilities.swift
//  SwipeMatchFirestore
//
//  Created by Mohammed Hamdi on 4/13/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
