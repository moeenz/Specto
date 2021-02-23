//
//  ContentView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Speech

struct ContentView: View {

    init() {
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            SFSpeechRecognizer.requestAuthorization {_ in }
        }
    }

    var body: some View {
        RootView()
    }
}
