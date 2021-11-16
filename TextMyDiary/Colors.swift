//
//  colors.swift
//  TextMyDiary
//
//  Created by can ersoz on 15.01.2021.
//

import SwiftUI

enum ColorProfile {
    case DEFAULT
    case DENEME1
    case DENEME2
}

class Colors {
    static let instance = Colors()
    
    var primaryColor = Color(.systemOrange) //Color(red: 1, green: 153/255, blue:0) //Color(red: 197/255, green: 230/255, blue: 219/255, opacity: 1.0)
    var neutralColor = Color(.systemBackground)
    var whiteColor = Color(.white)
    var editColor = Color(.systemGray2)
    var navButtonColor = Color(.black)
    var bgGrayColor = Color(.systemGray6)

    var textBlack = Color(.darkText)
    var textGray = Color(.gray)
    var searchBarColor = Color(.systemGray6)
    var clearColor = Color(.clear)
    var profile: ColorProfile = .DENEME2 {
        didSet{ setColors() }
    }
    
    func setColors(){
    }
    
    init() {
         setColors()
    }

}
