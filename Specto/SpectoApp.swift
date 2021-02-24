//
//  SpectoApp.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

@main
struct SpectoApp: App {

    private let appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(appModel)
        }
    }
}
