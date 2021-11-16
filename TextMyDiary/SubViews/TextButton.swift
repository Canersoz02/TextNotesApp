//
//  TextButton.swift
//  TextMyDiary
//
//  Created by can ersoz on 17.02.2021.
//

import SwiftUI

struct TextButton: View {
    var text: String
    var onClick: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onClick?() }) {
            HStack {
                Spacer()
                Text(text)
                Spacer()
            }
        }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButton(text: "Forgot Password?")
    }
}
