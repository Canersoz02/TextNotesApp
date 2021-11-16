//
//  SignupPageGoodDesign.swift
//  TextMyDiary
//
//  Created by can ersoz on 25.01.2021.
//

import SwiftUI

struct ErrorView: View {
    @Binding var error: Error?
    var body: some View {
        HStack {
            Spacer()
            Text(error?.localizedDescription ?? "")
                .font(.footnote)
                .foregroundColor(Color.red)
                .padding(.horizontal)
            Spacer()
        }
        
    }
}

struct SuccessView: View {
    @Binding var text: String?
    var body: some View {
        HStack {
            Spacer()
            Text(text ?? "")
                .font(.footnote)
                .foregroundColor(Color.green)
                .padding(.horizontal)
            Spacer()
        }
        
    }
}

struct loginForm: View {
    @Binding var email: String
    @Binding var password: String
    var body: some View {
        SignupLoginInputView(imageSystemName: "envelope.fill", headline: "Email adress", textFieldPrompt: "Email", secure: false, inputText: $email)
            .padding(.horizontal)
            .padding(.bottom, 7)
        
        SignupLoginInputView(imageSystemName: "key.fill", headline: "Password", textFieldPrompt: "Password", secure: true, inputText: $password)
            .padding(.horizontal)
            .padding(.bottom, 7)
    }
}

struct LoginPageGoodDesign: View {
    @State var password: String = ""
    @State var email: String = ""
    @State var error: Error? = nil
    @State var loading: Bool = false
    @State var successText: String? = nil
    @EnvironmentObject var authHandler: AuthHandler
    
    var vw: CGFloat = UIScreen.main.bounds.size.width / 100
    var vh: CGFloat = UIScreen.main.bounds.size.height / 100
    
    var body: some View {
        ZStack {
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: -40*vw, y: -40*vh)
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: 50*vw, y: 50*vh)
                VStack (alignment: .leading) {
                    AuthPageHeader(image: Image("LogoFlat"), text: "Welcome Back!", blackImage: false)
                        .padding(.bottom, 8*vh)
                    loginForm(email: $email, password: $password)
                    if loading {
                        SpinnerView()
                    }
                    else {
                        TextButton(text: "Forgot password?") {
                            loading = true
                            successText = ""
                            email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                            authHandler.forgotPassword(email: email) { error in
                                self.error = error
                                loading = false
                                if error == nil {
                                    successText = "Password reset email sent!"
                                }
                            }
                        }
                    }
                    
                    ErrorView(error: $error)
                    SuccessView(text: $successText)
                    Spacer()
                    LoadingButton(text: "Log In", loading: $loading){
                        loading = true
                        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        authHandler.logInUser(email: email, password: password) { error in
                            self.error = error
                            loading = false
                        }
                    }
                    Spacer()
                    TextButton(text: "Don't have an account? Sign Up!"){
                        withAnimation { authHandler.state = .signup }
                    }
                    Spacer()
                }.frame(maxWidth: 600)
            }.ignoresSafeArea(.keyboard)
    }
}

struct LoginPageGoodDesign_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginPageGoodDesign()
                .previewDevice("iPad Pro (11-inch) (2nd generation)")
            LoginPageGoodDesign()
                .previewDevice("iPhone 8")
            LoginPageGoodDesign()
                .previewDevice("iPhone 8")
            LoginPageGoodDesign()
                .previewDevice("iPhone 12 Pro")
        }
    }
}
