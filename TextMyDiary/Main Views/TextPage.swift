//
//  TextPage.swift
//  TextMyDiary
//
//  Created by can ersoz on 27.12.2020.
//

import SwiftUI
import Firebase

struct TextOrBulletView: View {
    @Binding var isBullet: Bool
    @State var entry: Entry
    var body: some View {
        if isBullet {
                BulletView(entry: entry)
        }
        else {
            TextView(entry: entry)
        }
    }
}

struct MessageView: View {
    @ObservedObject var entryHandler: EntryHandler
    @Binding var entries: [Entry]
    @State var pendingScroll: DispatchWorkItem?
    @State var atBottom: Bool = true
    @State var lastCount: Int = 0
    @Binding var isBullet: Bool
    private let showKeyboardNotification =
        NotificationCenter.Publisher(
            center: NotificationCenter.default,
            name: UIResponder.keyboardWillShowNotification
        )
        .makeConnectable()
        .autoconnect()
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(entries, id: \.self) { entry in
                        // Display Timestamp if sufficient time has passed
                        if entries.firstIndex(of: entry) == 0 ||
                            hasTimedOut(entry1: entries[entryHandler.entries.firstIndex(of: entry)! - 1], entry2: entry, timeoutHours: 1) {
                            TimeView(time: entry.time)
                        }
                        // Display Actual Text Message
                        HStack {
                            if !isBullet {
                                Spacer(minLength: 64)
                            }
                            TextOrBulletView(isBullet: $isBullet, entry: entry)
                                    .contentShape(RoundedRectangle(cornerRadius: 16))
                                    .contextMenu(
                                        ContextMenu {
                                            Button(action: {
                                                UIPasteboard.general.string = entry.text
                                                //copiedText = true
                                            }) {
                                                Image(systemName:"doc.on.doc")
                                                Text("Copy")
                                            }
                                            Button(action: {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                    entryHandler.deleteEntry(entry: entry)
                                                }
                                            }) {
                                                Image(systemName:"trash")
                                                Text("Delete")
                                            }
                                            
                                            Button(action: {
                                                let items = [entry.text]
                                                let av = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                                            }) {
                                                Image(systemName:"square.and.arrow.up")
                                                Text("Share")
                                            }
                                        }
                                    )
                            if isBullet {
                                Spacer()
                            }
                        }
                    }.onChange(of: entryHandler.entries.count) { count in
                        if count > lastCount{
                            print("SCRTOLL ", entryHandler.entries.count)
                            scrollToLast(proxy: scrollView)
                        }
                        self.lastCount = count
                    }
                    Color.clear.frame(height: 4).id("Bottom")
                        .onDisappear(perform: {
                            atBottom = false
                            print("---------- not at bottom no more")
                        })
                        .onAppear(perform: {
                            atBottom = true
                            print("----------- at bottom")
                        })
                }.padding([.horizontal, .top])
            }.onReceive(showKeyboardNotification) { _ in
                if atBottom {
                    scrollToLast(proxy: scrollView)
                }
            }.onAppear {
                scrollToLast(proxy: scrollView)
            }
        }
    }
   
    func scrollToLast(proxy: ScrollViewProxy) {
        pendingScroll?.cancel()
        let newScroll = DispatchWorkItem {
            //withAnimation(.linear(duration: 0.05)) {
                proxy.scrollTo("Bottom", anchor: .bottom)
            //}
        }
        pendingScroll = newScroll
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newScroll)
    }
}

struct InputView: View {
    var entryHandler: EntryHandler
    @State var textInput: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .bottom) {
                Text(textInput.isEmpty ? "A" : textInput)
                    .lineLimit(4)
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .overlay(
                        TextEditor(text: $textInput)
                            .padding(.top, 2)
                            .padding(.horizontal, 12)
                            .background(
                                ZStack {
                                    Color(UIColor.secondarySystemBackground)
                                    HStack {
                                        Text("Type a message")
                                            .foregroundColor(Color(UIColor.placeholderText))
                                            .padding(.leading, 17.5)
                                        Spacer()
                                    }.opacity(textInput.isEmpty ? 1.0 : 0.0)
                                }
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    )
                    .font(Font.system(.body, design: .rounded))
                
                Button(action: {
                    if !textIsEmpty(text: textInput) {
                        entryHandler.newEntry(text: textInput, sender: "Can Ersoz", attachments: "None")
                        textInput = ""
                    }
                }) {
                    Image(systemName: "arrow.up")
                        .font(Font.body.bold())
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30, alignment: .center)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(.bottom, 6)
                }.disabled(textInput.isEmpty)
            }.padding(8)
        }
    }
}

struct TextPage: View {
    @State var copiedText: Bool = false
    @State var viewState = CGSize.zero
    @ObservedObject var entryHandler: EntryHandler
    @ObservedObject var topic: Topic
    @State var newName: String = ""
    @State var editMode: Bool = false
    @State var isBullet: Bool = false
    
    init(topic: Topic){
        self.topic = topic
        entryHandler = EntryHandler(topic: topic.id)
        entryHandler.startEntryListener()
        //self.topic.name = top.name
        
        //self.topic.time = top.time
        //self.topic.id = top.id
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            MessageView(entryHandler: entryHandler, entries: $entryHandler.entries, isBullet: $isBullet)
                .onTapGesture {
                    closeKeyboard()
                }
            Spacer(minLength: 0)
                .background(Color.clear)
                .foregroundColor(.clear)
            InputView(entryHandler: entryHandler)
            //.offset(y: viewState.height)
            //.animation(.spring())
            /*.gesture(
             DragGesture()
             .onChanged { value in
             self.viewState = value.translation
             print("\(value)")
             }
             .onEnded { value in
             print("ended")
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
             self.viewState = CGSize.zero
             }
             )*/
        }.toolbar {
            ToolbarItem(placement: .principal) {
                if editMode {
                    VStack {
                        TextField("Enter new topic name", text: $newName)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .padding(.horizontal)
                            .frame(maxWidth: 250)
                        Rectangle().frame(height: 2)
                            .padding(.horizontal)
                            .foregroundColor(.black)
                    }
                } else {
                    Text("\(topic.name)")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
              (editMode ?
                Button("Save") {
                    if textIsEmpty(text: newName) {
                        print("EMPTY")
                        editMode = false
                    }
                    
                    else {
                        topic.changeName(newName: newName){
                            print("name changed")
                            editMode = false
                        }
                    }
                }
                :
                Button("Edit") {
                    newName = topic.name
                    editMode = true
                }
              )
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isBullet.toggle()
                }) {
                    Image(systemName: isBullet ? "message" : "note.text")
                }
            }
            
          }.navigationBarTitleDisplayMode(.inline)
    }
}

struct TextPage_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(alignment: .trailing){
            //(topic: Topic(name: "Deneme", time: Timestamp(), id: "id"))
            ForEach(["hello","hello", "hello",
                     "Heleoleoal elgale dfodsfjsa dojdfojadsofj",
                     "Bu yogurdu sarımsaklasak da mı saklasak, sarımsaklamasak da mı saklasak",
                     "A",
                     "ASD"], id:\.self) {text in
                TextView(entry:Entry(text: text, time: Timestamp(), attachments: "", sender: "", id: ""))
            }
        }
    }
}
