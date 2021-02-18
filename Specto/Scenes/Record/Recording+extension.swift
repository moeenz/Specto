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
}
