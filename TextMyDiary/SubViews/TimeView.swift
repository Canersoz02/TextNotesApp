//
//  TimeView.swift
//  TextMyDiary
//
//  Created by can ersoz on 8.01.2021.
//

import SwiftUI
import Firebase

struct TimeView: View {
    @State var time: Timestamp
    //@State var date: Date = Date()
    var body: some View {
        Text(getDateString(timestamp: time))
            .font(.subheadline)
            .bold()
            .foregroundColor(.gray)
        +
        Text(getTimeString(timestamp: time))
            .font(.subheadline)
            .fontWeight(.light)
            .foregroundColor(.gray)
    }
    
    func getDateString(timestamp: Timestamp) -> String {
        let date = timestamp.dateValue()
        if Calendar.current.isDateInToday(date) {
            return "Today "
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday "
        } else {
            let date = timestamp.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE, MMM d "
            return dateFormatter.string(from: date)
        }
    }
    
    func getTimeString(timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let date = timestamp.dateValue()
        return dateFormatter.string(from: date)
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView(time: Timestamp())
    }
}
