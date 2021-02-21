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

    @State private var isPlaying = true
    
    var onPlayFinishHandler: (() -> Void)?

    /// We use this Environment field to modify presentation status.
    @Environment(\.presentationMode) var presentation

    var discAndCover: some View {
        RecordItemView(
            image: item.image,
            keywords: item.keywords,
            displayMode: isPlaying ? .startPlaying : .finishPlaying
        )
    }

    var body: some View {
        ZStack {
            if isPlaying {
                RecordItemView(
                    image: item.image,
                    keywords: item.keywords,
                    coverOffset: 0,
                    keywordsContainerOffset: UIScreen.main.bounds.maxY,
                    displayMode: .startPlaying
                )
                .frame(width: 300, height: 300, alignment: .center)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isPlaying = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            onPlayFinishHandler?()
                        }
                    }
                }
            } else {
                RecordItemView(
                    image: item.image,
                    keywords: item.keywords,
                    coverOffset: UIScreen.main.bounds.maxY,
                    keywordsContainerOffset: 200,
                    displayMode: .finishPlaying
                )
                .frame(width: 300, height: 300, alignment: .center)
            }
        }.hiddenNavigationBarStyle()
    }
}
