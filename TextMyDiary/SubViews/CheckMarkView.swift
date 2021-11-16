//
//  CheckMarkView.swift
//  TextMyDiary
//
//  Created by can ersoz on 2.02.2021.
//

import SwiftUI

struct CheckMarkView<T: Equatable>: View {
    @Binding var state: T
    @State var desired: T
    @State var text: String
    var onChange: ((Bool) -> Void)? = nil
    var body: some View {
        Button(action:{
            state = desired
            onChange?(state == desired)
        }) {
            HStack {
                Text(text)
                Spacer()
                if state == desired {
                    Image(systemName: "checkmark.circle.fill").resizable().foregroundColor(Color.blue).frame(width: 22, height: 22)
                }
                else {
                    Circle().stroke(Color.blue).frame(width: 22, height: 22)
                }
            }.contentShape(Rectangle())
        }.buttonStyle(PlainButtonStyle())
    }
}

struct CheckMarkView_Previews: PreviewProvider {
    static var previews: some View {
        CheckMarkView(state: .constant(false), desired: true, text: "You wanta some potatoo")
    }
}
