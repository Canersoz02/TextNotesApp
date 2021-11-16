//
//  ChangePasswordAlert.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 11/4/20.
//
import SwiftUI

struct TextPromptAlert: View {
    @State var input = ""
    @State var title = ""
    @State var fieldTitle = ""
    @State var isSecure = false
    
    var onCancel: (() -> Void)? = nil
    var onDone: ((String)-> Void)? = nil
    
    var body: some View {
        
        VStack() {
          Text(title)
            .font(.headline)
            .foregroundColor(.black)
            .padding(.top)
            
            VStack(spacing:0){
                if isSecure {
                    SecureField(fieldTitle, text: $input)
                        .padding(8)
                      .background(Color.white)
                      .foregroundColor(.black)
                      .font(.subheadline)
                }
                else {
                    TextField(fieldTitle, text: $input)
                      .padding(8)
                      .background(Color.white)
                      .foregroundColor(.black)
                      .font(.subheadline)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
            .padding()
          
            VStack(spacing: 0){
                Divider()
                  .padding(0)
                HStack(spacing: 0) {
                  Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                      onCancel?()
                  }, label: {
                    Text("Cancel")
                      .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  })
                  .frame(maxWidth: .infinity)
                  .contentShape(Rectangle())
                  Divider().padding(0)
                  Button(action: {
                      onDone?(input)
                  }) {
                      Text("Done")
                          .bold()
                          .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                  }.frame(maxWidth: .infinity)
                  .contentShape(Rectangle())

                }
                .frame(height: 44)
                .foregroundColor(Color.black)
            }
        }
        .background(Color.white.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(width: 250)
    }
}


struct PromptPreviews: PreviewProvider {
    
    static var previews: some View {
        TextPromptAlert(input: "123456", title: "Password", fieldTitle: "Password", isSecure: true, onCancel: nil, onDone: nil)
    }
}
