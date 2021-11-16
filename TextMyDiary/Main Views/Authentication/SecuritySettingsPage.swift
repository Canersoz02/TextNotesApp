//
//  SecuritySettingsPage,.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import SwiftUI

struct SecuritySettingsPageTexts: View {
    var body: some View {
        Text("Would you like to enable additional privacy measures?")
            .font(.headline)
        
        Text("You can always change your decision later.")
            .fixedSize(horizontal: true, vertical: true)
            .font(.callout)
            .padding(.top, 5)
    }
}
struct SecuritySettingsPage: View {
    
    @ObservedObject var securityHandler = SecurityHandler.instance
    @State var showSetAppPasword: Bool = false
    @State var password: String = ""
    @State var currentPreference: SecurityPreference = .neither
    
    var vw: CGFloat = UIScreen.main.bounds.size.width / 100
    var vh: CGFloat = UIScreen.main.bounds.size.height / 100
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: -40*vw, y: -40*vh)
            Circle().foregroundColor(ColorScheme.primaryColor)
                .offset(x: 50*vw, y: 50*vh)
            VStack(alignment: .leading) {
                AuthPageHeader(image: Image(systemName: "lock.square"), text: "Keep curious eyes out", blackImage: true)
                    .padding(.bottom, 8*vh)
                    .padding(.top, 2*vh)
                SecuritySettingsPageTexts()
                    .padding(.horizontal)
                    //.padding(.bottom)
                Divider()
                CheckMarkView(state: $currentPreference, desired: .both, text: "Use password & biometrics") { _ in
                    showSetAppPasword = true
                }.padding()
            
                CheckMarkView(state: $currentPreference, desired: .password, text: "Use password") { _ in
                    showSetAppPasword = true
                }.padding()
            
                CheckMarkView(state: $currentPreference, desired: .neither, text: "I'm good for now") { _ in
                    showSetAppPasword = false
                    password = ""
                }.padding()
                Spacer()
                LoadingButton(text: "Done", loading: .constant(false)) {
                    securityHandler.tempPreference = currentPreference
                    securityHandler.updateSecuritySettings()
                    securityHandler.updatePassword(newPassword: password)
                    AuthHandler.instance.state = .done
                }.padding()
                Spacer()
            }.frame(maxWidth: 600)
            .ignoresSafeArea(.keyboard)
        
            if showSetAppPasword && password == "" {
                Color.black.opacity(0.65)
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
                TextPromptAlert(title: "Enter new password", fieldTitle: "password", isSecure: true,
                                onCancel: {
                                    showSetAppPasword = false
                                    self.currentPreference = .neither
                                },
                                onDone: { password in
                                    if password == "" {
                                        print("ERROR")
                                    }
                                    else {
                                        self.password = password
                                        self.showSetAppPasword = false
                                    }
                                })
            }
        }.ignoresSafeArea(.keyboard)
    }
}

struct SecuritySettingsPage_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            SecuritySettingsPage()
            SecuritySettingsPage()
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            SecuritySettingsPage()
                .previewDevice("iPhone 8")
        }
    }
}
