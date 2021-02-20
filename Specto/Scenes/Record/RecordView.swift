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
            
         
            Spacer()
            visualizer
            Spacer()
            
        
            Text(viewModel.text).truncationMode(.head).frame(height: 30).padding(100)
            HStack(spacing: 100) {
                
                Button(action: {
                    
                    
                }) {
                    Image(systemName: "circle.grid.2x2").resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                }
            
            ZStack {
                Circle().stroke(lineWidth: 4).fill(Color.red).frame(width: 60, height: 60)
                
                RoundedRectangle(cornerRadius: viewModel.recording ? 5 : 25).foregroundColor(Color.red).frame(width: viewModel.recording ? 20 : 50, height: viewModel.recording ? 20 : 50).onTapGesture {
                    
                    withAnimation(.easeOut(duration: 0.2)){
                        
                        if viewModel.recording {
                            viewModel.setImage(visualizer.asImage(size: CGSize(width: 350, height: 350)))
                            viewModel.stopSession()
                            
                        } else {
                            viewModel.startSession()
                        }
                        viewModel.recording.toggle()
                    }
                }
            }
                
                
                
                NavigationLink(destination: LazyView(GalleryView())) {
                    Image(systemName: "square.and.arrow.up").resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30)
                }.buttonStyle(PlainButtonStyle())
                
              
            
            
            }.padding(.bottom)
            
            // We can use viewModel.amplitudes to render AudioVisualizer view here
        }//.navigationTitle("Record")
        
        
    }
    
    var visualizer: some View { AudioVisualizer(amplitudes:  viewModel.amplitudes, recording: viewModel.recording).frame(width: 350, height: 350)}
    
    private func grantPermissions() {
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
}
