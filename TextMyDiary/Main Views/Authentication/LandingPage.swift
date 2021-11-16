//
//  LandingPage.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import SwiftUI

struct LandingView: View {

    var body: some View{
        ZStack{
            //ColorScheme.primaryColor
                //.ignoresSafeArea(.all)
            VStack{
            Image("FinalIconNoShadow")
                .resizable()
                .scaledToFill() // <=== Saves aspect ratio
                .frame(width: 200.0, height:200)
                .cornerRadius(200)
                .padding(20)
            Text("Loading...")
                .font(.title2)
                .fontWeight(.bold)
            }
        }
        /*VStack {
            
            Image("LogoFlat").resizable().frame(width: 408 * 3/5, height: 341 * 3/5).padding()
            
            Rectangle()
                .frame(width: 200, height: 10, alignment: .leading)
                .cornerRadius(10)
                .padding(.top, 50)
                .padding(.leading, 20)
                .frame(width: UIScreen.main.bounds.size.width, alignment: .leading)
            
            Text("Hi there, \nWelcome to Text Notes")
                .fontWeight(.bold)
                .font(.system(size: 40, design: .rounded))
                .padding(.trailing)
                .padding(.leading, 20)
                .padding(.bottom, 20)
                .frame(width: UIScreen.main.bounds.size.width, alignment: .leading)
            
            ProgressView("Loading…", value: downloadAmount, total: 100)
                .font(.headline)
                .padding(20)
                
        }
 */
    }
}
