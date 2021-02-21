//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Kingfisher
import Speech

typealias NavDismissHandler = () -> Void

struct GalleryView: View {
    
    // View model controlling GalleryView state.
    @StateObject var viewModel = GalleryViewModel()
    
    @Namespace private var animation
    @State private var show: Bool = false
    
    @State private var pushLink = false
    
    @State private var bottomPaneOffset: CGFloat = 0
    
    // Our grid consists  of two equal size columns hence the .flexible() modifier.
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        // Disable the default slide animation in navigation views.
        UINavigationBar.setAnimationsEnabled(false)
        
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            SFSpeechRecognizer.requestAuthorization {_ in }
        }
    }
    
    var emptyGallery: some View {
        Text("No recordings yet")
            .font(.system(size: 32, weight: .ultraLight, design: .default))
            .offset(y: -50)
    }
    
    
    
    var recordButton: some View {
        NavigationLink(
            destination: RecordView(),
            label: {
                ZStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red)
                            .frame(height: 50, alignment: .center)
                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                            .shadow(color: Color.gray, radius: 2, x: 1, y: 1)
                    }
                    Text("New Recording")
                        .font(.system(size: 18, weight: .heavy, design: .default))
                        .foregroundColor(Color.white)
                }
            }
        )
    }
    
    var bottomPaneContainer: some View {
        ZStack {
            if viewModel.touchedOne != nil {
                bottomPane
                    .offset(y: bottomPaneOffset)
                    .onAppear {
                        withAnimation {
                            bottomPaneOffset = 400
                        }
                    }
            } else {
                bottomPane
            }
        }
    }

    var bottomPane: some View {
        ZStack {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 81/255, green: 81/255, blue: 81/255))
                    .frame(height: 120, alignment: .center)
                    
            }
            .edgesIgnoringSafeArea(.bottom)
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color(red: 81/255, green: 81/255, blue: 81/255))
                    .frame(height: 50, alignment: .bottom)
                    
            }
            .edgesIgnoringSafeArea(.bottom)
            NavigationLink(destination: RecordView()) {
                RecordButton()
                    .frame(height: 150, alignment: .bottom)
            }
        }.frame(height: 150, alignment: .bottom)
    }

    var galleryItems: some View {
        ZStack {
            if let item = viewModel.touchedOne {
                RecordItemView(image: item.image,
                               keywords: item.keywords,
                               displayMode: .fixed)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.touchedOne = nil
                        }
                    }
                    .matchedGeometryEffect(id: String(item.id), in: animation)
                    .frame(width: 300, height: 300, alignment: .center)
                    .offset(y: -48)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 50) {
                        ForEach(viewModel.items) { item in
                            RecordItemView(image: item.image,
                                           keywords: item.keywords,
                                           displayMode: .fixed)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        viewModel.touchedOne = item
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            pushLink = true
                                        }
                                    }
                                }.matchedGeometryEffect(id: String(item.id), in: animation)
                                .frame(width: 150, height: 150)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    var body: some View {

        NavigationView {
            ZStack {
                Color(red: 26 / 255, green: 26 / 255, blue: 26 / 255).edgesIgnoringSafeArea(.all)
                if viewModel.isEmpty {
                    emptyGallery
                } else {
                    if let touchedOne = viewModel.touchedOne {
                        NavigationLink(
                            destination: PlayView(item: touchedOne, onPlayFinishHandler: onPlayFinished),
                            isActive: $pushLink,
                            label: {
                                EmptyView()
                            }
                        )
                    }
                    galleryItems
                }
                VStack {
                    Spacer()
                    bottomPaneContainer
                }
            }
        }
    }
    
    func onPlayFinished() {
        withAnimation(.spring()) {
            viewModel.touchedOne = nil
        }
    }
}
