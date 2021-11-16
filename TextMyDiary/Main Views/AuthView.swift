//
//  AppView.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authHandler: AuthHandler
    
    var body: some View {
        switch authHandler.state {
        
        case .landing:
            LandingView()

        case .signup:
            SignupPageGoodDesign()
            
        case .login:
            LoginPageGoodDesign()
        
        case .security:
            SecurityPage()
                .padding()
                .navigationViewStyle(StackNavigationViewStyle())
            
        case .securitySettings:
            SecuritySettingsPage()
                .navigationViewStyle(StackNavigationViewStyle())
            
        case .done:
            AppView()
                .environmentObject(AppHandler.instance)
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}
