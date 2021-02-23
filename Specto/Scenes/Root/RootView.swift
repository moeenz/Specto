//
//  RootView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/22/21.
//

import SwiftUI
import Speech

struct RootView: View {

    @StateObject private var reducer = RootReducer()

    @State private var isRecordSheetOpen = false

    @State private var zoomedItem: GalleryItem?

    init() {
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
                .opacity(reducer.nowPlaying == nil ? 1: 0.5)
                .onTapGesture {
                    if reducer.nowPlaying == nil {
                        isRecordSheetOpen.toggle()
                    }
                }
                .sheet(isPresented: $isRecordSheetOpen) {
                    RecordView(onSessionComplete: {
                        reducer.fetchLibraryItems()
                    })
                }
        }
    }

    var body: some View {
        ZStack {
            background
            VStack {
                if reducer.displayMode == .playing {
                    PlayView(item: reducer.nowPlaying!,
                             onPlayFinished: onPlayFinished)
                } else {
                    GalleryView(displayMode: reducer.displayMode,
                                onGalleryItemSelected: onGalleryItemSelected,
                                onZoomInAnimationComplete: onZoomInAnimationComplete,
                                onZoomOutAnimationComplete: onZoomOutAnimationComplete,
                                onZoomOutAnimationStarted: onZoomOutAnimationStarted,
                                reducer: reducer)
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

    func onGalleryItemSelected(_ item: GalleryItem) {
        reducer.nowPlaying = item
        reducer.displayMode = .zoomIn
    }

    func onPlayFinished() {
        reducer.displayMode = .zoomOut
    }

    func onShrinkAnimationComplete() {
        reducer.nowPlaying = nil
    }

    func onZoomInAnimationComplete() {
        reducer.displayMode = .playing
    }

    func onZoomOutAnimationStarted() {
        reducer.displayMode = .grid
    }

    func onZoomOutAnimationComplete() {
        reducer.displayMode = .grid
        reducer.nowPlaying = nil
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
