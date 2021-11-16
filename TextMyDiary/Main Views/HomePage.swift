//
//  HomePage.swift
//  TextMyDiary
//
//  Created by can ersoz on 27.12.2020.
//

import SwiftUI
import Firebase

struct HomePageHeader: View {
    @ObservedObject var profileListener = ProfileHandler.instance
    func getName() -> String {
        if profileListener.name.count > 10 {
            return "\n"+profileListener.name
        }
        
        else {
            return profileListener.name
        }
    }
    
    var body: some View {
        Text("Welcome Back, \(getName())")
            .font(.title)
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ColorScheme.primaryColor)
            .cornerRadius(24, corners: [.bottomRight])
            .background(ColorScheme.neutralColor) // Ustteki yarım dairenin arkası
            .foregroundColor(ColorScheme.textBlack)
    }
}

struct EntriesSectionTitle: View {
    
    @State private var searchEnabled = false
    @Binding var search: String
    var body: some View {
        VStack(spacing: 16) {
            Group {
                HStack {
                    Text("Recent Entries")
                        .fontWeight(.semibold)
                        .font(.title2)
                    Spacer()
                    Image(systemName: searchEnabled ? "xmark" : "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            //withAnimation {
                                searchEnabled = !searchEnabled
                            //}
                            if(!searchEnabled){search = ""}
                        }
                }
                if searchEnabled {
                    TextField("Search...", text: $search)
                        .padding(8)
                        .padding(.horizontal, 8)
                        .background(ColorScheme.searchBarColor)
                        .cornerRadius(8)
                }
            }.padding(.horizontal)
            Divider()
        }
        .padding(.top)
        .background(ColorScheme.neutralColor)
        .cornerRadius(24, corners: [.topLeft])
        .background(ColorScheme.primaryColor)
    }
}

struct HomePage: View {
    
    @EnvironmentObject var appHandler: AppHandler
    @ObservedObject var topicHandler: TopicHandler
    
    @State var search: String = ""
    @State var isLoading: Bool = false
    @State var showDeleteConfirmation = false
    @State var toBeDeleted: IndexSet?

    func removeRows(at offsets: IndexSet) {
        print("offsets: \(offsets)")
        toBeDeleted = offsets
        print("toBeDeleted: \(offsets)")
        for index in offsets {
            topicHandler.topics[index].show = false
        }
        self.showDeleteConfirmation = true
        /*for index in offsets {
            topicHandler.deleteTopic(index: index)
        }*/
    }
    
    func createNewEntry() {
        isLoading = true
        topicHandler.createNewTopic { t in
            isLoading = false
            guard let topic = t else { return }
            appHandler.currentTopic = topic
            appHandler.state = .textPage
        }
    }
    
    var scrollViewStickyHeader: some View {
        GeometryReader { geo in
            if geo.frame(in: .global).minY <= 0 {
                ColorScheme.primaryColor.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            } else {
                ColorScheme.primaryColor
                    .offset(y: -geo.frame(in: .global).minY)
                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
            }
        }.frame(minHeight: 0)
    }
    func fakeFunction(_ a: Bool) -> Bool { return true }
    var body: some View {
        ZStack {
            List {
                scrollViewStickyHeader
                    .listRowInsets(EdgeInsets())
                Section(header: HomePageHeader().listRowInsets(EdgeInsets())) {
                }.textCase(nil)
                
                Section(header: EntriesSectionTitle(search: $search).listRowInsets(EdgeInsets())) {
                    if fakeFunction(topicHandler.hackVar){
                    ForEach(topicHandler.topics, id: \.self) { topic in
                        if (search == "" || topic.name.lowercased().contains(search.lowercased())) && topic.show {
                            EntryCellView(topic: topic)
                                .environmentObject(topicHandler)
                                .onTapGesture {
                                    AppHandler.instance.setTopic(topic: topic)
                                }
                        }
                    }
                    .onDelete(perform: removeRows)
                    }
                }.textCase(nil)
            }
            .environment(\.defaultMinListRowHeight, 0)
            .listStyle(PlainListStyle())
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        appHandler.state = .settingsPage
                    }) {
                        Image(systemName: "gearshape")
                            .renderingMode(.template)
                            .foregroundColor(ColorScheme.navButtonColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isLoading {
                        ProgressView()
                    }
                    
                    else {
                        Button(action: {
                            createNewEntry()
                        }) {
                            Image(systemName: "square.and.pencil")
                                .renderingMode(.template)
                                .foregroundColor(ColorScheme.navButtonColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }.onAppear {
            UITableView.appearance().showsVerticalScrollIndicator = false
            }
            DeleteConfirmationAlert(showingAlert: $showDeleteConfirmation, offsets: $toBeDeleted, topicHandler: topicHandler).opacity(showDeleteConfirmation ? 1 : 0)
        }
        .onAppear(){
            appHandler.state = .topicsPage
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    
    static var previews: some View {
        let topicHandler = TopicHandler(isDummy: true)
        HomePage(topicHandler: topicHandler)
            .environmentObject(AppHandler.instance)
    }
}
