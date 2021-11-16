//
//  AccountView.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 10/5/20.
//

import SwiftUI
import StoreKit
import FirebaseAuth
struct ProfileSection: View {
    @Binding var isEditing: Bool
    @Binding var username: String
    @Binding var showSetAccountPassword: Bool
    
    var body: some View {
        Section(header: Text("Profile")) {
            HStack {
                Text("Name")
                if isEditing {
                    TextField("Name", text: $username)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(ColorScheme.editColor)
                } else {
                    Text(username)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            HStack {
                Text("Email")
                Text(Auth.auth().currentUser?.email ?? "")
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Button("Change Account Password") {
                self.showSetAccountPassword = true
            }
            
        }
        .textCase(nil)
    }
}

struct SecuritySection: View {
    @ObservedObject var securityHandler: SecurityHandler = SecurityHandler.instance
    @Binding var isEditing: Bool
    @Binding var showSetAppPassword: Bool
    @Binding var newAppPassword: String
    var body: some View {
        Section(header: Text("Security").textCase(.none)) {
            CheckMarkView(state: $securityHandler.tempPreference, desired: .both, text: "Use password & biometrics")
                { _ in showSetAppPassword = true }.disabled(!isEditing)
            CheckMarkView(state: $securityHandler.tempPreference, desired: .password, text: "Use password")
                { _ in showSetAppPassword = true }.disabled(!isEditing)
            CheckMarkView(state: $securityHandler.tempPreference, desired: .neither, text: "I'm good for now")
                { _ in showSetAppPassword = false; newAppPassword = ""}.disabled(!isEditing)
            Button("Change App Password") {
                self.showSetAppPassword = true
                newAppPassword = ""
            }.disabled(!isEditing)
        }
    }
}

struct SubscriptionSection: View {
    var body: some View {
        Section(header: Text("Subscription")) {
            Button("Manage Subscription") {
                /*if session.subscribed {
                 let urlStr = "itms-apps://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/DirectAction/manageSubscriptions"
                 UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
                 } else {
                 AnalyticsManager.subscriptionEvent(action: "Show_Popup", type: .manage)
                 PurchaseManager.defaultManager.openPopup(type: .manage)
                 }*/
            }
        }.textCase(nil)
    }
}

struct AboutSection: View {
    var body: some View {
        Section(header: Text("About")) {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0")
                //Text("\(Bundle.main.appVersionShort) (\(Bundle.main.appVersionLong))")
            }
            
            Button("Rate") {
                requestReview()
            }
            
            WebLinkButton(title: "Help us improve", goToPage: .feedback)
            
            WebLinkButton(title: "Report a bug", goToPage: .bugReport)
            
            Button("Share") {
                let firstActivityItem = "Check out Text Notes!"//AppTexts.Account.ShareMessage
                let secondActivityItem = URL(string: "https://apps.apple.com/app/id1534594904")!
                let av = UIActivityViewController(activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
            }
        }.textCase(nil)
    }
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
          SKStoreReviewController.requestReview(in: scene)
        }
      }
}

struct LegalSection: View {
    var body: some View {
        
        Section(header: Text("Legal")) {
            WebLinkButton(title: "Terms", goToPage: .toc)
            WebLinkButton(title: "Privacy", goToPage: .privacy)
        }.textCase(nil)
        
    }
}

struct LeaveSection: View {
    var body: some View {
        
        Section {
            Button("Sign out") {
                AuthHandler.instance.signOut()
            }
        }.textCase(nil)
    }
}

struct PopUps: View {
    @Binding var showSetAppPassword: Bool
    @Binding var showSetAccountPassword: Bool
    @Binding var newAppPassword: String
    @ObservedObject var securityHandler: SecurityHandler = SecurityHandler.instance
    var body: some View {
        if showSetAppPassword && newAppPassword == "" {
            Color.black.opacity(0.65)
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            TextPromptAlert(title: "Enter new password", fieldTitle: "Password", isSecure: true,
                            onCancel: {
                                showSetAppPassword = false
                                self.securityHandler.tempPreference = .neither
                            },
                            onDone: { password in
                                if password == "" {
                                    print("ERROR")
                                }
                                else {
                                    newAppPassword = password
                                    print("-------------- \(newAppPassword)")
                                    self.showSetAppPassword = false
                                }
                            })
        }
        if showSetAccountPassword {
            Color.black.opacity(0.65)
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ChangePasswordAlert(showingAlert: $showSetAccountPassword)
        }
    }
}

struct AccountPage: View {
    
    //@EnvironmentObject private var session: UserSession
    @State var isEditing: Bool = false
    @State var showPasswordChange = false
    @State var showSetAppPasword = false
    
    @State var checkPassword = false
    @ObservedObject var securityHandler = SecurityHandler.instance
    @ObservedObject var profileHandler = ProfileHandler.instance
    @State var newAppPassword = ""
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Form {
                    ProfileSection(isEditing: $isEditing, username: $profileHandler.tempName, showSetAccountPassword: $showPasswordChange)
                    SecuritySection(isEditing: $isEditing, showSetAppPassword: $showSetAppPasword, newAppPassword: $newAppPassword)
                    AboutSection()
                    LegalSection()
                    LeaveSection()
                }
                .background(ColorScheme.bgGrayColor)
                .edgesIgnoringSafeArea(.bottom)
            }
            PopUps(showSetAppPassword: $showSetAppPasword, showSetAccountPassword: $showPasswordChange, newAppPassword: $newAppPassword)
        }
        .onDisappear(){
            securityHandler.resetTempPreferenece()
            profileHandler.resetTemp()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                (isEditing ?
                    Button("Save") {
                        if showPasswordChange || showSetAppPasword { return }
                        isEditing = false
                        if newAppPassword != "" {
                            securityHandler.password = newAppPassword
                        }
                        securityHandler.updateSecuritySettings()
                        profileHandler.updateUsername()
                        //session.user?.name = username.trimmingCharacters(in: .whitespacesAndNewlines)
                        //session.updateUser()
                    }
                    :
                    Button("Edit") {
                        if showPasswordChange || showSetAppPasword { return }
                        isEditing = true
                    }
                )
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(false)
    }
}

