//
//  TextMyDiaryApp.swift
//  TextMyDiary
//
//  Created by can ersoz on 27.12.2020.
//

import SwiftUI
import Firebase

@main
struct TextMyDiaryApp: App {
    var window: UIWindow?
    
    init() {
        FirebaseApp.configure()
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(ColorScheme.primaryColor)
        coloredAppearance.shadowColor = UIColor(ColorScheme.clearColor)

        let fontSize: CGFloat = 32
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)

        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(ColorScheme.textBlack)]
        coloredAppearance.largeTitleTextAttributes = [.font: systemFont, .foregroundColor: UIColor(ColorScheme.textBlack)]
                     
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(ColorScheme.textBlack)

        UITableView.appearance().backgroundColor = UIColor(ColorScheme.clearColor)
        UITableView.appearance().separatorStyle = .none

        let color = UIView()
        color.backgroundColor = UIColor(ColorScheme.clearColor)
        UITableViewCell.appearance().selectedBackgroundView = color
        
        UITextView.appearance().backgroundColor = UIColor(ColorScheme.clearColor)
    }
    
    var body: some Scene {
        WindowGroup {
            //SecurityPage()
            //SecuritySettingsPage()
            AuthView()
               .environmentObject(AuthHandler.instance)
            //LandingView()
            //SignupPageGoodDesign()
            //LoginPageGoodDesign()
        }
    }
}


