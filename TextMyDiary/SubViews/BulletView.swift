//
//  BulletView.swift
//  TextMyDiary
//
//  Created by can ersoz on 8.02.2021.
//

import SwiftUI
import Firebase

struct BulletView: View {
    @State var entry: Entry
    var body: some View {
        VStack(alignment: .leading) {
            //Divider()
            HStack(alignment: .top) {
                Circle()
                    .frame(width: 7, height: 7)
                    .padding(.top, 6)
                    .padding(.leading, 5)
                LinkedText(entry.text)
                    .font(.callout)
                    .padding(.leading, 5)
                    .padding(.trailing)
                Spacer()
            }.padding(.top, 5)
            .padding(.bottom, 5)
        }
    }
}

struct BulletView_Previews: PreviewProvider {
        static var previews: some View {
            BulletView(entry: Entry(text: "Hello how are you I'm fine thanks and you, me too thank you", time: Timestamp(), attachments: "", sender: "", id: ""))
    }
}

