//
//  RecordView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct RecordView: View {

    @ObservedObject var viewModel: RecordViewModel

    @Environment(\.presentationMode) private var presentationMode

    private let lpRecordWidth: CGFloat = 320
    private let lpRecordHeight: CGFloat = 320

    var background: some View {
        Color(red: 81 / 255, green: 81 / 255, blue: 81 / 255).edgesIgnoringSafeArea(.all)
    }

    var timer: some View {
        StopWatchView(color: Color.gray)
    }

    var visualizer: some View {
        AudioVisualizer(amplitudes: viewModel.amplitudes,
                        recording: viewModel.recording)
            .frame(width: lpRecordWidth, height: lpRecordHeight)
    }

    var liveTranscription: some View {
        Text(viewModel.text)
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .heavy, design: .default))
            .italic()
            .lineLimit(1)
            .truncationMode(.head)
            .padding(80)
    }

    var stopButton: some View {
        StopButton()
            .onTapGesture {
                if viewModel.recording {
                    viewModel
                        .setImage(visualizer.asImage(size: CGSize(width: lpRecordWidth,
                                                                  height: lpRecordHeight)))
                    viewModel.stopSession()
                    viewModel.onSessionComplete?()
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }

    var body: some View {
        ZStack {
            background
            VStack {
                timer
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                Spacer()
            }
            VStack {
                Spacer()
                visualizer
                    .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        viewModel.startSession()
                        viewModel.recording.toggle()
                    }
                liveTranscription
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                Spacer()
            }
            VStack {
                Spacer()
                stopButton
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
        }
        .alert(isPresented: $viewModel.recordSessionFailed) {
            Alert(
                title: Text("Problem Occurred"),
                message: Text("Could not start recording session at the moment"),
                dismissButton: .default(Text("Dismiss")))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .hiddenNavigationBarStyle()
    }
}
