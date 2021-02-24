//
//  RootView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/22/21.
//

import SwiftUI
import Speech

struct RootView: View {

    @EnvironmentObject var appModel: AppModel

    @ObservedObject var viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel

        grantAllPermissions()
    }

    var background: some View {
        Color(red: 26 / 255, green: 26 / 255, blue: 26 / 255).edgesIgnoringSafeArea(.all)
    }

    var recordPane: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 81 / 255, green: 81 / 255, blue: 81 / 255))
                .frame(height: 200)
                .offset(y: 100)
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 81 / 255, green: 81 / 255, blue: 81 / 255))
                .frame(height: 100, alignment: .center)
            RecordButton()
                .opacity(appModel.nowPlaying == nil ? 1: 0.5)
                .onTapGesture {
                    if appModel.nowPlaying == nil {
                        viewModel.recordButtonTouched()
                    }
                }
                .sheet(isPresented: $viewModel.isRecordSheetOpen) {
                    RecordView(viewModel: RecordViewModel(onSessionComplete: {
                        appModel.refreshLibrary()
                    }))
                }
        }
    }

    var body: some View {
        ZStack {
            background
            VStack {
                if appModel.visibleScene == .recordPlaying, let nowPlaying = appModel.nowPlaying {
                    PlayView(viewModel: PlayViewModel(item: nowPlaying,
                                                      onPlayFinishedHandler: appModel.onPlayFinished))
                } else {
                    GalleryView(items: appModel.library,
                                nowPlaying: appModel.nowPlaying,
                                visibleScene: appModel.visibleScene,
                                onGalleryItemSelected: appModel.onGalleryItemSelected,
                                onZoomInAnimationComplete: appModel.onZoomInAnimationComplete,
                                onZoomOutAnimationStarted: appModel.onZoomOutAnimationStarted,
                                onZoomOutAnimationComplete: appModel.onZoomOutAnimationComplete)
                        .padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 80, trailing: 0))

            VStack {
                Spacer()
                recordPane
                    .frame(maxHeight: 100)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }

    private func grantAllPermissions() {
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            SFSpeechRecognizer.requestAuthorization { _ in }
        }

        if AVAudioSession.sharedInstance().recordPermission != .granted {
            AVAudioSession.sharedInstance().requestRecordPermission { _ in }
        }
    }
}
