//
//  RecordView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Speech

struct RecordView: View {
    
    var onSessionComplete: (() -> Void)?

    private let lpRecordWidth: CGFloat = 320
    private let lpRecordHeight: CGFloat = 320

    @ObservedObject var viewModel: RecordViewModel

    @Environment(\.presentationMode) var presentationMode

    init(onSessionComplete: (() -> Void)?) {
        viewModel = RecordViewModel()
        self.onSessionComplete = onSessionComplete
    }

    var background: some View {
        Color(red: 81 / 255, green: 81 / 255, blue: 81 / 255).edgesIgnoringSafeArea(.all)
    }

    var timer: some View {
        StopWatchView(color: Color.gray)
    }

    var visualizer: some View {
        AudioVisualizer(amplitudes: viewModel.amplitudes,
                        recording: viewModel.recording)
            .frame(width: lpRecordWidth, height: lpRecordHeight)}

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
                                                                  height: lpRecordHeight)
                        )
                    )
                    viewModel.stopSession()
                    onSessionComplete?()
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
                    .padding(EdgeInsets(top: 80, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        viewModel.startSession()
                        viewModel.recording.toggle()
                    }
                liveTranscription
                Spacer()
            }
            VStack {
                Spacer()
                stopButton
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .hiddenNavigationBarStyle()
    }
}
