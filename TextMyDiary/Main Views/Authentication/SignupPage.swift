//
//  SignupPage.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import SwiftUI

enum AuthFormMode {
    case signup, login
}

struct SignupPage: View {
    @EnvironmentObject var authHandler: AuthHandler
    
    @State private var formMode: AuthFormMode = .signup
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State private var usernameInput: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Enter email", text: $emailInput)
            
            TextField("Enter password...", text: $passwordInput)
            
            if formMode == .signup {
                TextField("Enter username...", text: $usernameInput)
            }
            
            Button(action: {
                if formMode == .signup {
                    authHandler.signUpUser(email: emailInput, password: passwordInput, username: usernameInput)
                } else {
                    authHandler.logInUser(email: emailInput, password: passwordInput)
                }
            }) {
                if formMode == .signup {
                    Text("Sign Up")
                } else {
                    Text("Login")
                }
            }
            Spacer()
            Button(action: {
                if formMode == .signup {
                    formMode = .login
                } else {
                    formMode = .signup
                }
            }, label: {
                if formMode == .signup {
                    Text("Already have an acoount? Log in")
                } else {
                    Text("New User? Signup Today")
                }
            })
        }.padding(.horizontal)
    }
}

