//
//  RecordView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Speech

struct RecordView: View {

    private var viewModel: RecordViewModel?

    init() {
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            grantPermissions()
        }

        viewModel = RecordViewModel()
        viewModel?.startSession()
    }

    var body: some View {
        Text("Record View")
            .padding()
        
        // We can use viewModel.amplitudes to render AudioVisualizer view here
    }
    
    private func grantPermissions() {
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
}
