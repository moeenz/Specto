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
    @State private var recording = false
    
    
    init() {
        
        viewModel = RecordViewModel()
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            grantPermissions()
        }
    }
    
    var body: some View {
        VStack {
            
            ZStack {
                
            visualizer
                
            }
            
            
            Spacer()
            Text(viewModel.text).padding()
            HStack(spacing: 100) {
                
                Button(action: {
                    
                    
                }) {
                    Image(systemName: "circle.grid.2x2").resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                }
            
            ZStack {
                Circle().stroke(lineWidth: 4).fill(Color.red).frame(width: 60, height: 60)
                
                RoundedRectangle(cornerRadius: recording ? 5 : 25).foregroundColor(Color.red).frame(width: recording ? 20 : 50, height: recording ? 20 : 50).onTapGesture {
                    
                    withAnimation(.easeOut){
                        
                        if recording {
                            viewModel.stopSession()
                            viewModel.setImage(visualizer.asImage(size: CGSize(width: 350, height: 350)))
                        } else {
                            viewModel.startSession()
                        }
                        self.recording.toggle()
                    }
                }
            }
                
                
                
                NavigationLink(destination: GalleryView()) {
                    Image(systemName: "square.and.arrow.up").resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                }.buttonStyle(PlainButtonStyle())
                
              
            
            
            }.padding(.bottom)
            
            // We can use viewModel.amplitudes to render AudioVisualizer view here
        }//.navigationTitle("Record")
        
        
    }
    
    var visualizer: some View { AudioVisualizer(amplitudes:  viewModel.amplitudes).frame(width: 350, height: 350)}
    
    private func grantPermissions() {
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
}
