//
//  RootView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/22/21.
//

import SwiftUI

struct RootView: View {

    @StateObject private var reducer = RootReducer()

    @State private var isRecordSheetOpen = false
    
    @State private var zoomedItem: GalleryItem?

    var background: some View {
        Color(red: 26 / 255, green: 26 / 255, blue: 26 / 255).edgesIgnoringSafeArea(.all)
    }
    
    var recordPane: some View {
        ZStack {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 81/255, green: 81/255, blue: 81/255))
                    .frame(height: 120, alignment: .center)
            }
            .edgesIgnoringSafeArea(.bottom)
            RecordButton()
                .onTapGesture {
                    isRecordSheetOpen.toggle()
                }
                .frame(height: 150, alignment: .bottom)
                .sheet(isPresented: $isRecordSheetOpen) {
                    RecordView()
                }
        }.frame(height: 150, alignment: .bottom)
    }

    var body: some View {
        ZStack {
            background
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
            VStack {
                Spacer()
                recordPane
            }
        }
    }

    func onGalleryItemSelected(_ item: GalleryItem) {
        print("select")
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
}
