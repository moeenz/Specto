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
            discAndCover
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        isPlaying = false
                    }
                }
                .frame(width: 300, height: 300, alignment: .center)
        }.hiddenNavigationBarStyle()
    }
}
