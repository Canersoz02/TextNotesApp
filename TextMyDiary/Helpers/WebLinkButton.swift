//
//  WebLinkButton.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 11/8/20.
//
import SwiftUI

struct WebLinkButton: View {
  
  let title: String
  let goToPage: WebPageLinks
  @State var linkPage: WebPageLinks? = nil
  
  var body: some View {
    Button(title) {
      linkPage = goToPage
    }.sheet(item: $linkPage) { page in
      SafariView(url: page.url)
    }
  }
  
}
