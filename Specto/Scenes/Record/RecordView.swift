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
        VStack {
        

            AudioVisualizer(amplitudes:  viewModel.amplitudes).frame(width: 300, height: 300)

            
            Text(viewModel.text)
        Button("start recording") {
            viewModel.startSession()
            
        }
            
            Button("Stop recording") {
                viewModel.stopSession()
                
            }
        
        NavigationLink("All recordings", destination: LazyView(GalleryView()))

        // We can use viewModel.amplitudes to render AudioVisualizer view here
        }//.navigationTitle("Record")
    }
    
    private func grantPermissions() {
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
}
