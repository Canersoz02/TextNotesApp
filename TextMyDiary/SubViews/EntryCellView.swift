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
                .font(.headline)
            
            Text("Note for \(topic.getDateString())")
                .font(.subheadline)
                .foregroundColor(ColorScheme.textGray)
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .background(ColorScheme.neutralColor)
    }
}


struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EntryCellView(topic: Topic(name: "Thoughts", time: Timestamp(), id: ""))
            EntryCellView(topic: Topic(name: "Thoughts", time: Timestamp(), id: ""))
                .preferredColorScheme(.dark)
        }
    }
}

