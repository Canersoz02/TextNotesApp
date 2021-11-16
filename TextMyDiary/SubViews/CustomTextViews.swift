//
//  CustomTextViews.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 10/29/20.
//
import SwiftUI

struct TitleText: View {
  
  var titleText: String
  var isRounded = false
  
  var body: some View {
    Text(titleText)
      .font(.system(.title, design: isRounded ? .rounded : .default))
      .fontWeight(.bold)
  }
  
}

struct Title3Text: View {
  
  var titleText: String
  
  var body: some View {
    Text(titleText)
      .font(.title3)
      .fontWeight(.regular)
  }
  
}

struct PromptText: View {
  
  var prompt: String
  
  var body: some View {
    Text(prompt)
      .lineLimit(nil)
      .multilineTextAlignment(.leading)
      .fixedSize(horizontal: false, vertical: true)
      .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
    .foregroundColor(ColorScheme.whiteColor)
  }
}
