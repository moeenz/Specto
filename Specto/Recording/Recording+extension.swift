//
//  Recording+extension.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import Foundation

extension Recording {
    func getKeywords() -> [String] {
        return keywords?.components(separatedBy: ",") ?? []
    }

    func getCleanKeywords() -> [String] {
        let processedKeywords = getKeywords()

        if processedKeywords == [] || processedKeywords ==  [""] {
            return ["No", "Context", "Detected"]
        }

        return processedKeywords
    }
}
