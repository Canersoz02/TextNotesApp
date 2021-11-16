//
//  KeyboardResponder.swift
//  TextMyDiary
//
//  Created by can ersoz on 14.01.2021.
//

import Foundation
import SwiftUI
/*
class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published var isActive = false
    @Published var changing = false
    @Published var currentHeight = CGFloat(0)
    private var lastHeight: CGFloat = 0
    init(center: NotificationCenter = .default) {
        print("initttt")
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        print("DEIN ")
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        print("Activeeeeee")
        isActive = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardSize.height >= lastHeight{
                currentHeight = keyboardSize.height
                lastHeight = currentHeight
                changing = true
            } else {
                currentHeight = lastHeight
                changing = false
            }
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        print("deactive")
        isActive = false
        currentHeight = 0
    }
}
*/
