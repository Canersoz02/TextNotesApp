//
//  AppHandler.swift
//  TextMyDiary
//
//  Created by can ersoz on 14.01.2021.
//

import Foundation
import Firebase

enum AppState {
    case topicsPage
    case textPage
    case settingsPage
}

class AppHandler: ObservableObject {
    
    @Published var currentTopic: Topic? = nil
    @Published var state: AppState = .topicsPage
    
    static var instance = AppHandler()
    
    private init() { }
    
    func setTopic(topic: Topic) {
        currentTopic = topic
        state = .textPage
    }
    
}
