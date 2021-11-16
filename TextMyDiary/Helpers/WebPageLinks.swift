//
//  WebPageLinks.swift
//  Goals
//
//  Created by Mehmet Can Alaca on 11/8/20.
//
import Foundation

enum WebPageLinks: CaseIterable, Identifiable {
  case feedback, bugReport, toc, privacy

  var id: String { url.absoluteString }

  var url: URL {
    switch self {
    case .feedback:
      return URL(string: "https://textnotes.app/feedback.html")!
    case .bugReport:
      return URL(string: "https://textnotes.app/bugreport.html")!
    case .toc:
      return URL(string: "https://textnotes.app/terms_of_use.pdf")!
    case .privacy:
      return URL(string: "https://textnotes.app/privacy_policy.pdf")!
    }
  }
  
}
