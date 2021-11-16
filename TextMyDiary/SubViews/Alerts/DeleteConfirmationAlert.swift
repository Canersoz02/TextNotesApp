//
//  ChangePasswordAlert.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 11/4/20.
//

import SwiftUI

struct DeleteConfirmationAlert: View {
    @Binding var showingAlert: Bool
    @Binding var offsets: IndexSet?
    @ObservedObject var topicHandler: TopicHandler
    
  var body: some View {
    ZStack {
      Color.black.opacity(0.65)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      VStack(spacing: 0) {
        Text("Confirm deletion")
          .font(.headline)
          .foregroundColor(.black)
          .padding(.vertical)
                  
        Divider()
        
        HStack(spacing: 0) {
          Button(action: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            guard let offs = offsets else {return }
            for index in offs {
                topicHandler.topics[index].show = true
            }
            self.showingAlert.toggle()
          }, label: {
            Text("Cancel")
              .bold()
          })
          .frame(maxWidth: .infinity)
          .contentShape(Rectangle())
          Divider()
          Button("Delete") {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            guard let offs = offsets else {return }
            for index in offs {
                topicHandler.deleteTopic(index: index)
            }
            self.showingAlert.toggle()
            
          }
          .frame(maxWidth: .infinity)
          .contentShape(Rectangle())
        }
        .frame(height: 44)
        .foregroundColor(Color.black)
      }
      .background(Color.white.opacity(0.95))
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .frame(width: 250)
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

