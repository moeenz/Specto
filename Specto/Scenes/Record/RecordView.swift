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
    }

    var visualizer: some View {
        AudioVisualizer(amplitudes: viewModel.amplitudes,
                        recording: viewModel.recording)
            .frame(width: 350, height: 350)}
    
    var liveTranscription: some View {
        Text(viewModel.text).truncationMode(.head).frame(height: 30).padding(100)
    }
    
    var stopButton: some View {
        StopButton()
            .onTapGesture {
                if viewModel.recording {
                    viewModel.setImage(visualizer.asImage(size: CGSize(width: 350, height: 350)))
                    viewModel.stopSession()
                }
            }
    }

    var body: some View {
        ZStack {
            Color(red: 81 / 255, green: 81 / 255, blue: 81 / 255).edgesIgnoringSafeArea(.all)
            visualizer
                .onAppear {
                    viewModel.startSession()
                    viewModel.recording.toggle()
                }
            VStack {
                Spacer()
                liveTranscription
                stopButton
            }
        }
        .hiddenNavigationBarStyle()
    }
}
