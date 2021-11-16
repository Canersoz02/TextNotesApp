//
//  ChangePasswordAlert.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 11/4/20.
//
import SwiftUI

class AuthError: NSObject, LocalizedError {
    var desc = ""
    init(str: String) {
        desc = str
    }
    override var description: String {
        get {
            return desc
        }
    }
    //You need to implement `errorDescription`, not `localizedDescription`.
    var errorDescription: String? {
        get {
            return self.description
        }
    }
}

struct ChangePasswordAlert: View {
  
  //@EnvironmentObject private var session: UserSession
  @State var oldPassword = ""
  @State var newPassword = ""
  @State var newPasswordVerify = ""
  @Binding var showingAlert: Bool
  @State var error: Error?
    @State var action: Bool = false
  var body: some View {
    ZStack {
      
      VStack(spacing: 0) {
        Text("Update Password")
          .font(.headline)
          .foregroundColor(.black)
          .padding(.vertical)
        if let err = error {
          Text(err.localizedDescription)
            .font(.footnote)
            .foregroundColor(Color.black)
            .padding(.horizontal)
        } else {
          Text("")
            .font(.footnote)
            .foregroundColor(.black)
            .padding(.horizontal)
        }
                  
        VStack(spacing: 0) {
          SecureField("old password", text: $oldPassword)
            .padding(8)
            .background(Color.white)
            .foregroundColor(.black)
            .font(.subheadline)
          Divider()
          SecureField("New password", text: $newPassword)
            .padding(8)
            .background(Color.white)
            .foregroundColor(.black)
            .font(.subheadline)
          Divider()
          SecureField("Verify new password", text: $newPasswordVerify)
            .padding(8)
            .background(Color.white)
            .foregroundColor(.black)
            .font(.subheadline)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
        .padding()
        
        Divider()
        
        HStack(spacing: 0) {
          Button(action: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

            self.showingAlert.toggle()
          }, label: {
            Text("Cancel")
              .bold()
          })
          .frame(maxWidth: .infinity)
          .contentShape(Rectangle())
          Divider()
            Button(action: {
                action = true
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            self.error = nil
            if newPassword != newPasswordVerify {
                self.error = AuthError(str: "Passwords Don't Match")
                return
            }
            AuthHandler.instance.changePasswordRequest(with: newPassword, was: oldPassword) { error in
                action = false
              guard let err = error else {
                print("SUCCESS")
                self.showingAlert.toggle()
                return
              }
              self.error = err
            }
          }, label: {
            if action {
                SpinnerView(darken: false).padding()
            }
            else {
                Text("Done")
            }
          })
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
