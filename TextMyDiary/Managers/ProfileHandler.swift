//
//  ProfileHandler.swift
//  TextMyDiary
//
//  Created by can ersoz on 14.01.2021.
//

import Foundation
import SwiftUI
import Firebase

class ProfileHandler: ObservableObject {
    @Published var name: String = ""
    @Published var tempName: String = ""
    static var instance: ProfileHandler = ProfileHandler()
    private var registration: ListenerRegistration? = nil
    let db = Firestore.firestore()
    init() {
        startUsernameListener()
    }
    
    func stopUsernameListener(){
        registration?.remove()
        registration = nil
    }
    
    func startUsernameListener(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("profiles").document(userID)
            .addSnapshotListener { documentSnapshot, error in
                if let e = error{
                    print("error: \(e)")
                }
                
                else if let document = documentSnapshot {
                    self.name = document["name"] as! String? ?? ""
                    self.tempName = self.name
                }
                else{
                    print("else")
                }
            }
    }
    func updateUsername(){
        db.collection("profiles").document(Auth.auth().currentUser?.uid ?? "").setData(["name": self.tempName], merge: true)
        self.name = self.tempName
    }
    
    func resetTemp(){
        self.tempName = self.name
    }
}

