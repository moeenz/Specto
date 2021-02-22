//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Kingfisher
import Speech

struct GalleryView: View {

    var displayMode: RootDisplayMode

    var onGalleryItemSelected: ((GalleryItem) -> Void)?
    var onZoomInAnimationComplete: (() -> Void)?
    
    var onZoomOutAnimationComplete: (() -> Void)?
    var onZoomOutAnimationStarted: (() -> Void)?

    @ObservedObject var reducer: RootReducer

    @Namespace private var animation

    // Our grid consists  of two equal size columns hence the .flexible() modifier.
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var emptyGallery: some View {
        Text("No recordings yet")
            .font(.system(size: 32, weight: .ultraLight, design: .default))
            .foregroundColor(Color.white)
            .offset(y: -50)
    }

    var galleryItems: some View {
        ZStack {
            if displayMode == .grid {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 50) {
                            ForEach(reducer.library) { item in
                                RecordItemView(image: item.image,
                                               keywords: item.keywords,
                                               displayMode: .fixed)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            onGalleryItemSelected?(item)
                                        }
                                    }
                                    .matchedGeometryEffect(id: String(item.id), in: animation)
                                    .frame(width: 150, height: 150)
                                    .padding(EdgeInsets(top: 64, leading: 0, bottom: 0, trailing: 0))
                                    
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                RecordItemView(image: reducer.nowPlaying!.image,
                               keywords: reducer.nowPlaying!.keywords,
                               displayMode: .fixed)
                    .matchedGeometryEffect(id: String(reducer.nowPlaying!.id), in: animation)
                    .frame(width: 300, height: 300)
                    .onAppear {
                        if displayMode == .zoomIn {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                onZoomInAnimationComplete?()
                            }
                        } else if displayMode == .zoomOut {
                            withAnimation(.spring()) {
                                onZoomOutAnimationStarted?()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() +  1) {
                                onZoomOutAnimationComplete?()
                            }
                        }
                    }
            }
        }
    }
    
    var body: some View {
        ZStack {
            if reducer.isEmpty {
                emptyGallery
            } else {
                galleryItems
                    .padding()
            }
        }
    }
}
