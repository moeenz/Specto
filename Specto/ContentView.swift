//
//  ContentView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct ContentView: View {

    @State private var shouldDisplayInfo: Bool = !ContentView.isInfoDisplayed()

    var body: some View {
        if shouldDisplayInfo {
            InfoView(onDismissHandler: onDismissHandler)
        } else {
            RootView()
        }
    }

    func onDismissHandler() {
        UserDefaults.standard.setValue(true, forKey: "IsInfoDisplayed")
        shouldDisplayInfo = false
    }

    private static func isInfoDisplayed() -> Bool {
        if let displayed = UserDefaults.standard.value(forKey: "IsInfoDisplayed") as? Bool {
            return displayed == true
        }

        return false
    }
}
