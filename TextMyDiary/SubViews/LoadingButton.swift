//
//  LoadingButton.swift
//  TextMyDiary
//
//  Created by can ersoz on 17.02.2021.
//

import SwiftUI

struct LoadingButton: View {
    var text: String
    @Binding var loading: Bool
    var onClick: (() -> Void)? = nil
    
    var body: some View {
        if loading {
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .frame(maxWidth:150, maxHeight: 40, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .foregroundColor(ColorScheme.whiteColor)
                    .padding()
                Spacer()
            }
        }
        
        else {
            Button(action: {
                loading = true
                onClick?()
            }) {
                HStack {
                    Spacer()
                    Text(text)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth:150, maxHeight: 40, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
        }
    }
}

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadingButton(text: "Login", loading: .constant(false))
    }
}
