//
//  TopicManager.swift
//  TextMyDiary
//
//  Created by can ersoz on 11.01.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics
class TopicHandler: ObservableObject {
    @Published var topics: [Topic] = []
    @Published var hackVar = false
    let db = Firestore.firestore()
    
    init(isDummy: Bool) {
        if isDummy {
            topics = [
                Topic(name: "Name 1", time: Timestamp(), id: "id1"),
                Topic(name: "Name 2", time: Timestamp(), id: "id2"),
                Topic(name: "Name 3", time: Timestamp(), id: "id3"),
                Topic(name: "Name 4", time: Timestamp(), id: "id4"),
                Topic(name: "Name 5", time: Timestamp(), id: "id5"),
                Topic(name: "Name 6", time: Timestamp(), id: "id6"),
                Topic(name: "Name 7", time: Timestamp(), id: "id7")
            ]
        } else {
            startTopicsListener()
        }
    }
    
    func startTopicsListener() {
        db.collection("Messages").document(Auth.auth().currentUser!.uid).collection("Topics").order(by: "time", descending: false).addSnapshotListener { querySnapshot, error in
                if let e = error{
                    print("error: \(e)")
                }
                else if let changes = querySnapshot?.documentChanges{
                    changes.forEach{ change in
                        if change.type == .added {
                            self.topics.insert(Topic(name: change.document["name"] as! String, time: change.document["time"] as! Timestamp, id: change.document.documentID), at: 0)
                            print(self.topics.count)
                        }
                        
                        else if change.type == .removed {
                            //self.topics = self.topics.filter { $0.id != change.document.documentID}
                            self.topics.removeAll(where: { $0.id == change.document.documentID })
                        }
                        else if change.type == .modified {
                            guard let i = self.topics.firstIndex(where: { $0.id == change.document.documentID }) else { return }
                            self.topics[i].name = change.document["name"] as! String
                            self.topics[i].time = change.document["time"] as! Timestamp
                        }
                    }
                }
                else{
                    print("else")
                }
            }
    }
    
    func createNewTopic(_ topicName: String = "", completion: ((Topic?) -> ())?){
        //TODO: Clean all of this up by wrapping our data types with holding classes
        //      and proper codable serialization/deserialization
        Analytics.logEvent("Topic Created", parameters: [:])
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let name = topicName == "" ? todayString() : topicName
        let ref = db.collection("Messages").document(userID).collection("Topics").document()
            
        ref.setData(["name": todayString(),
                     "time": Timestamp()]){ err in
            if let e = err {
                completion?(nil)
            }
            else{
                ref.getDocument{document, err in
                    if let document = document, document.exists {
                        completion?(Topic(name: document["name"] as! String, time: document["time"] as! Timestamp, id: document.documentID))
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    func deleteTopic(index: Int){
        Analytics.logEvent("Topic Deleted", parameters: [:])
        if index >= 0 && index < topics.count {
            deleteTopic(topic: topics[index])
        }
        else {
            print("Index Out Of Bounds")
        }
    }
    
    func deleteTopic(topic: Topic) {
        deleteTopic(id: topic.id)
    }
    
    func deleteTopic(id: String){
        db.collection("Messages").document(Auth.auth().currentUser!.uid).collection("Topics").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    func timestampToStr(ts: Timestamp) -> String {
        let date = ts.dateValue()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        return formatter1.string(from: date)
    }
    
    func todayString() -> String{
        let today = Date()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "E, d MMM y"
        return formatter3.string(from: today)
    }
    
}
