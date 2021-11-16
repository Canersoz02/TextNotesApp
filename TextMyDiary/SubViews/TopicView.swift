//
//  EntryCellView.swift
//  TextMyDiary
//
//  Created by can ersoz on 27.12.2020.
//

import SwiftUI
import Firebase

struct EntryCellView: View {
    
    @EnvironmentObject var topicHandler: TopicHandler
    @ObservedObject var topic: Topic

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(topic.name)
                .foregroundColor(.black)
                .font(.headline)
            
            Text("Diary entry for \(topic.getDateString())")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            AppHandler.instance.setTopic(topic: topic)
            withAnimation {
                AppHandler.instance.state = .textPage
            }
        }
        .contextMenu {
            Button(action: { topicHandler.deleteTopic(topic: topic) }) {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
        .background(ColorScheme.whiteColor)
    }
}


struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        EntryCellView(topic: Topic(name: "Thoughts", time: Timestamp(), id: ""))
    }
}

