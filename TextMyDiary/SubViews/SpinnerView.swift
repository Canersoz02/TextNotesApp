//
//  SpinnerView.swift
//  TextMyDiary
//
//  Created by can ersoz on 15.01.2021.
//

import SwiftUI

struct SpinnerView: View {
    var darken: Bool = true
    var body: some View {
        ZStack {
            if darken {
                Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
            }
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SpinnerView()
        }
    }
}
