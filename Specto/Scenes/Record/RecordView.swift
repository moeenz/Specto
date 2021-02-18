//
//  RecordView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Speech

struct RecordView: View {

    @ObservedObject var viewModel: RecordViewModel

    init() {
        
        viewModel = RecordViewModel()
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            grantPermissions()
        }

        
        
    }

    var body: some View {
        Text("Record View")
            .padding()
        
        //if let p = viewModel.amplitudes {
        AudioVisualizer(amplitudes:  viewModel.amplitudes)
        //}
        Button("start recording") {
            viewModel.startSession()
            
        }

        // We can use viewModel.amplitudes to render AudioVisualizer view here
    }
    
    private func grantPermissions() {
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
}
