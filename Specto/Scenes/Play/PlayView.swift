//
//  PlayView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//
//
import SwiftUI

struct PlayView: View {

    var item: GalleryItem

    @StateObject private var viewModel = PlayViewModel()
    
    var onPlayFinished: (() -> Void)?

    /// We use this Environment field to modify presentation status.
    @Environment(\.presentationMode) private var presentation

    func buildDiscAndCoverView () -> RecordItemView {
        RecordItemView(
            image: item.image,
            keywords: item.keywords,
            coverOffset: viewModel.isPlaying ? 0 : UIScreen.main.bounds.maxY,
            keywordsContainerOffset: viewModel.isPlaying ? UIScreen.main.bounds.maxY : 200,
            displayMode: viewModel.isPlaying ? .startPlaying : .finishPlaying
        )
    }
    
    var discAndCover: some View {
        RecordItemView(
            image: item.image,
            keywords: item.keywords,
            coverOffset: viewModel.isPlaying ? 0 : UIScreen.main.bounds.maxY,
            keywordsContainerOffset: viewModel.isPlaying ? UIScreen.main.bounds.maxY : 200,
            displayMode: viewModel.isPlaying ? .startPlaying : .finishPlaying
        )
        .offset(y: -48)
        .frame(width: 300, height: 300, alignment: .center)
    }

    var body: some View {
        ZStack {
            Color(red: 26 / 255, green: 26 / 255, blue: 26 / 255).edgesIgnoringSafeArea(.all)
            if viewModel.isPlaying {
                discAndCover
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            viewModel.isPlaying = false

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                onPlayFinished?()
                            }
                        }
                    }
            } else {
                discAndCover
            }
        }
        .hiddenNavigationBarStyle()
    }
}
