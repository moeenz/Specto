//
//  PlayView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

struct PlayView: View {

    @ObservedObject var viewModel: PlayViewModel

    private let lpRecordWidth: CGFloat = 320
    private let lpRecordHeight: CGFloat = 320

    var largeKeywords: some View {
        VStack {
            Text(viewModel.item.keywords.joined(separator: "   "))
                .font(.system(size: 32, weight: .heavy, design: .default))
                .foregroundColor(viewModel.item.coverColor)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.01)
                .animate {
                    if viewModel.isPlaying {
                        viewModel.bringDownKeywords()
                    } else {
                        viewModel.pushUpKeywords()
                    }
                }
                .offset(y: viewModel.largeKeywordsOffset)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    var discAndCover: some View {
        RecordItemView(
            coverColor: viewModel.item.coverColor,
            coverFont: viewModel.item.coverFont,
            image: viewModel.item.image,
            keywords: viewModel.item.keywords,
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
                        viewModel.play()
                    }
                largeKeywords
            } else {
                discAndCover
                largeKeywords
            }
        }
            .alert(isPresented: $viewModel.playbackFailed) {
            Alert(
                title: Text("Problem Occurred"),
                message: Text("Could not play record at the moment"),
                dismissButton: .default(Text("Dismiss")))
        }
    }
}
