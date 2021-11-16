//
//  GlobalConvenience.swift
//  TextMyDiary
//
//  Created by can ersoz on 12.01.2021.
//

import Foundation
import SwiftUI

func closeKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func openKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

let ColorScheme = Colors.instance

func textIsEmpty(text: String) -> Bool {
    for char in text {
        if !char.isWhitespace {
            return false
        }
    }
    return true
}

func hasTimedOut(entry1: Entry, entry2: Entry, timeoutHours: Int) -> Bool {
    let diffHour = Calendar.current.dateComponents([.hour], from: entry1.time.dateValue(), to: entry2.time.dateValue())
    print(entry1.text, entry2.text)
    print("hour \(diffHour.hour)")
    return diffHour.hour ?? 0 >= timeoutHours
}
