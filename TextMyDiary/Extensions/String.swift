//
//  String.swift
//  TextMyDiary
//
//  Created by can ersoz on 14.02.2021.
//
import Foundation

extension String {

    func isValidURL() -> Bool {
        guard !contains("..") else { return false }
    
        let head     = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail
    
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)

        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }

}
