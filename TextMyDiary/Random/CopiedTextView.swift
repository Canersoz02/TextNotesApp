//
//  CopiedTextView.swift
//  TextMyDiary
//
//  Created by can ersoz on 2.01.2021.
//

import SwiftUI

struct CopiedTextView: View {
    @Binding var flag: Bool
    var body: some View {
        ZStack {
            Color.white
            Text("Copied text to clipboard")
        }.frame(width: 200, height: 40).cornerRadius(30).shadow(radius: 20).onAppear {
            let _delay = RunLoop.SchedulerTimeType(.init(timeIntervalSinceNow: 2.0))
            RunLoop.main.schedule(after: _delay) {
                self.flag.toggle()
            }
    }
    }
}
