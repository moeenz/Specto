//
//  InfoView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/23/21.
//

import SwiftUI

struct InfoView: View {

    var onDismissHandler: (() -> Void)?

    var background: some View {
        Color(red: 26 / 255, green: 26 / 255, blue: 26 / 255).edgesIgnoringSafeArea(.all)
    }

    private let appInfoText = """
    Specto is an audio visualizer application that also transcribes user input using Apple speech recognition API. Each recording session is tagged with highlighted keywords with TextRank algorithm. This application has been developed for SwiftUI Jam, Feb 2021.
    """
    
    var info: some View {
        ScrollView {
            VStack {
                Text("Specto")
                    .font(.system(size: 72, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))

                Image("InfoCover")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 240, alignment: .center)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))

                Text(appInfoText)
                    .font(.system(size: 18, weight: .thin, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))

                Text("Creative Director")
                    .font(.system(size: 14, weight: .heavy, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))

                Text("Taha Mousavi")
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))

                Text("Developed by")
                    .font(.system(size: 14, weight: .heavy, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))

                Text("Abbas Mousavi")
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))

                Text("Moeen Zamani")
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))

                Button(
                    action: {
                        onDismissHandler?()
                    },
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(minWidth: 200,
                                       idealWidth: UIScreen.main.bounds.width * 0.9,
                                       maxWidth: UIScreen.main.bounds.width * 0.9,
                                       minHeight: 50,
                                       idealHeight: 50,
                                       maxHeight: 50,
                                       alignment: .center)
                            Text("Dismiss Intro")
                                .foregroundColor(.white)
                        }
                    }
                ).padding(EdgeInsets(top: 60, leading: 20, bottom: 50, trailing: 20))
            }
        }
    }

    var body: some View {
        ZStack {
            background
            info
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
