//
//  AuthenticationPage.swift
//  TextMyDiary
//
//  Created by can ersoz on 29.12.2020.
//

import SwiftUI
import LocalAuthentication
import Firebase

struct SecurityPage: View {
    @State private var isUnlocked = false
    @State private var tryPassword = ""
    @EnvironmentObject var authHandler: AuthHandler
    @ObservedObject var securityHandler = SecurityHandler.instance
    
    var vw: CGFloat = UIScreen.main.bounds.size.width / 100
    var vh: CGFloat = UIScreen.main.bounds.size.height / 100
    
    var body: some View {
        ZStack {
            Circle().foregroundColor(ColorScheme.primaryColor)
                .frame(width: vw*100, height: vh*100)
                .offset(x: -40*vw, y: -5*vh)
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: 50*vw, y: 50*vh)
            Circle().foregroundColor(ColorScheme.primaryColor)
                .frame(width: 20*vw, height: 20*vw)
                .offset(x: 30*vw, y: -35*vh)
                //.frame(width: vw*20, height: vh*20)
                //.offset(x: -70*vw, y: -50*vh)
            
            VStack {
                HStack {
                    VStack(alignment: .leading){
                        Text(getGreeting() + ",")
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 40, design: .rounded))
                            .padding(.bottom)
                        Text("Enter password to start taking notes")
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .font(.title2)
                    }
                    Spacer()
                }.padding(.horizontal)
                .padding(.bottom, 80)
                if securityHandler.preference == .both {
                    Text("").onAppear(perform: authenticate)
                }
                SecureField("Enter password", text: $tryPassword)
                    .padding()
                    .background(ColorScheme.bgGrayColor)
                    .cornerRadius(20)
                    .padding()
                Button(action: {
                    authHandler.signOut()
                }) {
                    Text("Forgot password?")
                }
                Button(action: {
                    if securityHandler.matchesPassword(tryPassword: tryPassword) {
                        AuthHandler.instance.state = .done
                    }
                }) {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth:150, maxHeight: 40, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .padding()
                }
            }.frame(maxWidth: 600)
        }
    }
    
    private func getGreeting() -> String {
            let hour = Calendar.current.component(.hour, from: Date())
        
            switch hour {
            case 0..<4:
                return "Hello"
            case 4..<12:
                return "Good morning"
            case 12..<18:
                return "Good afternoon"
            case 18..<24:
                return "Good evening"
            default:
                break
            }
            return "Hello"
        }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Protect your journal with biometric authentication"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        AuthHandler.instance.state = .done
                        print("Unlocked")
                    } else {
                        print("not unlocked")
                    }
                }
            }
        } else {
            print("No biometrics available")
        }
    }
    
    func skipAuth() {
        AuthHandler.instance.state = .done
    }
}
struct AuthenticationPage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SecurityPage()
            SecurityPage()
                .previewDevice("iPhone 12 Pro Max")
            SecurityPage()
                .previewDevice("iPhone 12 mini")
            SecurityPage()
                .previewDevice("iPhone 8")
        }
    }
}
