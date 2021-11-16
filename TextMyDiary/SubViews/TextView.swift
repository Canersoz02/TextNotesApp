//
//  TextView.swift
//  TextMyDiary
//
//  Created by can ersoz on 27.12.2020.
//

import SwiftUI
import Firebase

struct StringWrapper {
    var text: String
    var isLink: Bool
}

struct TextView: View {
    var maxChars = 400
    @State var entry: Entry
    @State var expanded: Bool = false

    var shouldExpand: Bool {
        entry.text.count > maxChars && expanded
    }
    var shouldPrefix: Bool {
        !expanded && entry.text.count > maxChars
    }
    /*
    func getFormattedTextArray(text: String) -> [StringWrapper] {
        let textArr = text.components(separatedBy: " ")
        var aggregator: [StringWrapper] = []
        var lastIndex: String.Index? = nil
        var count = 0
        for word in textArr {
            if word.isValidURL() {
                let range = text.range(of: word)
                if lastIndex == nil {
                    aggregator.append(StringWrapper(text: String(text[...range!.lowerBound]), isLink: false))
                }
                else {
                    aggregator.append(StringWrapper(text: String(text[lastIndex!...range!.lowerBound]), isLink: false))
                }
                aggregator.append(StringWrapper(text: word, isLink: true))
                lastIndex = range!.upperBound
            }
        }
        return aggregator
    }
    
    func getFormattedText(textArr: [StringWrapper]) -> some View {
        ForEach(0..<textArr.count){ i in
            if textArr[i].isLink {
                Text(textArr[i].text)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        <#code#>
                    }
            }
            else {
                Text(textArr[i].text)
            }
        }
    }
    */
    var text: some View {
        Group {
            if shouldExpand {
                VStack(alignment: .trailing){
                    LinkedText(entry.text)
                    Text("See Less")
                        .font(Font.headline.weight(.semibold))
                        .onTapGesture { expanded = false }
                }
            } else if shouldPrefix {
                VStack(alignment: .trailing){
                    LinkedText(entry.text.prefix(maxChars) + "...")
                    Text("See More")
                        .font(Font.headline.weight(.semibold))
                        .onTapGesture { expanded = true }
                }
            } else {
                LinkedText(entry.text)
            }
        }
    }
    var body: some View {
        text
            .foregroundColor(.white) // Text
            .padding(.horizontal,  16)
            .padding(.vertical, 8)
            .background(Color(.systemBlue)) // Blue background
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
    }
}

struct TextView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            ForEach(["hello","hello", "hello",
                 "Heleoleoal elgale dfodsfjsa dojdfojadsofj",
                 "Bu yogurdu sarımsaklasak da mı saklasak, sarımsaklamasak da mı saklasakBu yogurdu sarımsaklasak da mı saklasak, sarımsaklamasak da mı saklasak",
                 "A",
                 "ASD"], id:\.self) {text in
                TextView(entry:Entry(text: text, time: Timestamp(), attachments: "", sender: "", id: ""))
        }
    }
    }
}
