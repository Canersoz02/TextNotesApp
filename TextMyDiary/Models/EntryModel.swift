//
//  EntryModel.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import FirebaseFirestore
class Entry: Hashable, Equatable {
    var text: String
    var time: Timestamp
    var attachments: String
    var sender: String
    var id: String
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init (text: String, time: Timestamp, attachments: String, sender: String, id: String) {
        self.text = text
        self.time = time
        self.attachments = attachments
        self.sender = sender
        self.id = id
    }
}
