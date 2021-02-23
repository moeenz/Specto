//
//  PlayView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

struct PlayView: View {

    private let lpRecordWidth: CGFloat = 320
    private let lpRecordHeight: CGFloat = 320

    var item: GalleryItem

    var onPlayFinished: (() -> Void)?

    @StateObject private var viewModel = PlayViewModel()
    
    @State var largeKeywordsOffset: CGFloat = -500
    
    var largeKeywords: some View {
        VStack {
            Text(item.keywords.joined(separator: "   "))
                .font(.system(size: 32, weight: .heavy, design: .default))
                .foregroundColor(item.coverColor)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.01)
                .animate {
                    if viewModel.isPlaying {
                        largeKeywordsOffset = 40
                    } else {
                        largeKeywordsOffset = -500
                    }
                }
                .offset(y: largeKeywordsOffset)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    var discAndCover: some View {
        RecordItemView(
            coverColor: item.coverColor,
            coverFont: item.coverFont,
            image: item.image,
            keywords: item.keywords,
            coverOffset: viewModel.isPlaying ? 0 : UIScreen.main.bounds.maxY,
            displayMode: viewModel.isPlaying ? .startPlaying : .finishPlaying)
        .frame(width: lpRecordWidth, height: lpRecordHeight, alignment: .center)
        .offset(y: 15)
    }

    var body: some View {
        ZStack {
            Color(red: 26 / 255, green: 26 / 255, blue: 26 / 255).edgesIgnoringSafeArea(.all)
            if viewModel.isPlaying {
                discAndCover
                    .onAppear {
                        viewModel.play(item: item, onPlayFinishHandler: onPlayFinished)
                    }
                largeKeywords
            } else {
                discAndCover
                largeKeywords
            }
        }
        .hiddenNavigationBarStyle()
    }
}
