//
//  Date+extensions.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import Foundation

extension Date {
    var timeMilisUTC: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}
