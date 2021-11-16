//
//  Keyboard.swift
//  TextMyDiary
//
//  Created by can ersoz on 28.12.2020.
//

import SwiftUI
import Foundation
/*
struct Keyboard: ViewModifier {
    @State var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content.padding(.bottom, offset).onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.offset = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                self.offset = 0
            }
        }
    }
}

*/
