//
//  TopicModel.swift
//  TextMyDiary
//
//  Created by can ersoz on 11.01.2021.
//

import Foundation
import Firebase

class Topic: ObservableObject, Hashable, Equatable {
    @Published var name: String
    @Published var time: Timestamp
    @Published var id: String
    @Published var show: Bool = true
    let db = Firestore.firestore()
    
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init (name: String, time: Timestamp, id: String) {
        self.name = name
        self.time = time
        self.id = id
    }
    
    func changeName(newName: String, completion: (()->())?) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print(" NO USER ID")
            return
        }
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("Messages").document(userID).collection("Topics").document(self.id).setData(["name": newName], merge: true) { err in
                if let e = err {
                    print("error, couldn't change name")
                    completion?()
                }
                else {
                    print("changed here too")
                    self.name = newName
                    completion?()
                }
            }
        }
    }
    
    func isRelevant(input: String) -> Bool {
        return self.name.contains(input)
    }
    
    func getName() -> String {
        if self.name == "" {
            let date = self.time.dateValue()
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "E, d MMM y"
            return formatter3.string(from: date)
        }
        else {
            return self.name
        }
    }
    
    func getDateString() -> String {
        let date = self.time.dateValue()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: date)
    }

}
