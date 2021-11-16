//
//  EntryManager.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import SwiftUI
class EntryHandler: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var increased: Bool = true
    var topic: String
    let db = Firestore.firestore()
    
    init(topic: String){
        self.topic = topic
    }
    
    func startEntryListener() {
        if Auth.auth().currentUser?.uid != nil {
            db.collection("Messages").document(Auth.auth().currentUser!.uid).collection("Topics").document(self.topic).collection("Entries").order(by: "time", descending: false).addSnapshotListener { querySnapshot, error in
                if let e = error{
                    print("error: \(e)")
                }
                else if let changes = querySnapshot?.documentChanges{
                    changes.forEach{ change in
                        if change.type == .added {
                            let entry = Entry(text: change.document["text"] as! String,
                                              time: change.document["time"] as! Timestamp,
                                              attachments: change.document["attachments"] as! String,
                                              sender: change.document["sender"] as! String,
                                              id: change.document.documentID)
                            withAnimation {
                                self.entries.append(entry)
                            }
                            self.increased = !self.increased
                        }
                        else if change.type == .removed {
                            self.entries = self.entries.filter { $0.id != change.document.documentID}
                        }
                    }
                }
                else{
                    print("else")
                }
            }
        }
    }
    
    func newEntry(text: String, sender: String, attachments: String) {
        Analytics.logEvent("Text sent", parameters: [:])
        db.collection("Messages").document(Auth.auth().currentUser!.uid).collection("Topics").document(self.topic).collection("Entries").addDocument(data: [
            "text": text,
            "time": Timestamp(),
            "sender": sender,
            "attachments": attachments
        ]) { err in
            if let e = err {
                print("Error: \(e)")
            }
            else {
                print("document added succsessfully")
            }
        }
    }
    
    func deleteEntry(entry: Entry) {
        Analytics.logEvent("Text Deleted", parameters: [:])
        db.collection("Messages").document(Auth.auth().currentUser!.uid).collection("Topics").document(self.topic).collection("Entries").document(entry.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}
