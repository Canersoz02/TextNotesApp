//
//  AppView.swift
//  TextMyDiary
//
//  Created by can ersoz on 14.01.2021.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var appHandler: AppHandler
    @State private var presentEntry: Bool = false
    @State private var presentSettings: Bool = false
    var isPreview: Bool = false

    @ObservedObject private var topicHandler: TopicHandler
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
        self.topicHandler = TopicHandler(isDummy: isPreview)

    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let topic = appHandler.currentTopic, presentEntry {
                    NavigationLink(
                        destination: TextPage(topic: topic),
                        isActive: $presentEntry,
                        label: { EmptyView() }
                    ).frame(width: 0, height: 0)
                }   
                NavigationLink(
                    destination: AccountPage(),
                    isActive: $presentSettings,
                    label: { EmptyView() }
                ).frame(width: 0, height: 0)
                HomePage(topicHandler: topicHandler)
            }
            .onChange(of: appHandler.state) { value in
                presentEntry = value == .textPage
                presentSettings = value == .settingsPage
            }.onChange(of: appHandler.currentTopic) { value in
                if appHandler.state == .topicsPage && value != nil{
                    appHandler.state = .textPage
                }
            }.onChange(of: presentEntry) { value in
                if !value {
                    appHandler.currentTopic = nil
                    appHandler.state = .topicsPage
                }
            }.onChange(of: presentSettings) { value in
                if !value {
                    appHandler.state = .topicsPage
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(isPreview: true)
            .environmentObject(AppHandler.instance)
    }
}
