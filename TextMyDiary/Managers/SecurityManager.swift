//
//  SecurityManager.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CryptoSwift
enum SecurityPreference: String {
    case neither
    case password
    case both
}

class SecurityHandler: ObservableObject {
    @Published var preference: SecurityPreference = .neither
    @Published var tempPreference: SecurityPreference = .neither
    private var registration: ListenerRegistration? = nil
    
    var password: String? = nil {
        didSet { hasPassword = password != nil }
    }
    
    @Published var hasPassword: Bool = false
    let db = Firestore.firestore()
    
    static var instance = SecurityHandler()
    
    func stopSecuritySettingsListener(){
        registration?.remove()
        registration = nil
    }
    
    func startSecuritySettingsListener(onChange: ((SecurityPreference) -> Void)? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        registration = db.collection("security").document(userID)
            .addSnapshotListener { documentSnapshot, error in
                if let e = error{
                    print("error: \(e)")
                }
                
                else if let document = documentSnapshot {
                    if document.exists {
                        self.preference = SecurityPreference(rawValue: document["preference"] as? String ?? "neither") ?? .neither
                        if let password = document["password"] {
                            self.password = password as? String
                        }
                        self.tempPreference = self.preference
                    }
                    else {
                        self.preference = .neither
                        self.password = nil
                    }
                    onChange?(self.preference)
                }
                else{
                    print("else")
                }
            }
    }
    
    func updateSecuritySettings(completion: (() -> Void)? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else { completion?(); return }
        self.db.collection("security").document(userID).setData(["preference": self.tempPreference.rawValue,
                                                                 "password": self.password], merge: true)
        self.preference = self.tempPreference
        completion?()	
    }
    
    func updatePassword(newPassword: String, completion: (() -> Void)? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.db.collection("security").document(userID).setData([
            "password": newPassword.sha256(),
        ], merge: true){ _ in  completion?() }
    }
    
    func changePasswordRequest(with newPassword: String, was oldPassword: String, completion: ((String?) -> Void)? = nil) {
        if oldPassword == self.password {
            self.updatePassword(newPassword: newPassword){ completion?(nil) }
        }
        else {
            completion?("Incorrect password")
        }
    }
    
    func matchesPassword(tryPassword: String) -> Bool {
        return tryPassword.sha256() == self.password
    }
    
    func resetTempPreferenece() -> Void {
        self.tempPreference = self.preference
    }
}
