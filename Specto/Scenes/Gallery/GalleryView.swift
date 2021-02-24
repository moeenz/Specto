//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct GalleryView: View {

    @Namespace private var animation

    var items: [GalleryItem]
    var nowPlaying: GalleryItem?
    var visibleScene: AppVisibleScene

    var onGalleryItemSelected: ((GalleryItem) -> Void)?
    var onZoomInAnimationComplete: (() -> Void)?
    var onZoomOutAnimationStarted: (() -> Void)?
    var onZoomOutAnimationComplete: (() -> Void)?

    private let lpRecordWidth: CGFloat = 320
    private let lpRecordHeight: CGFloat = 320

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

    func buildRecordItemView(item: GalleryItem) -> RecordItemView {
        RecordItemView(coverColor: item.coverColor,
                       coverFont: item.coverFont,
                       image: item.image,
                       keywords: item.keywords,
                       displayMode: .fixed)
    }

    var galleryItems: some View {
        ZStack {
            if visibleScene == .gallery {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 50) {
                            ForEach(items) { item in
                                buildRecordItemView(item: item)
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            onGalleryItemSelected?(item)
                                        }
                                    }
                                    .matchedGeometryEffect(id: String(item.id), in: animation)
                                    .frame(width: 150, height: 150)
                                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            } else {
                VStack {
                    buildRecordItemView(item: nowPlaying!)
                        .matchedGeometryEffect(id: String(nowPlaying!.id), in: animation)
                        .frame(width: lpRecordWidth, height: lpRecordHeight)
                        .onAppear {
                            if visibleScene == .recordZoomIn {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    onZoomInAnimationComplete?()
                                }
                            } else if visibleScene == .recordZoomOut {
                                withAnimation(.easeInOut) {
                                    onZoomOutAnimationStarted?()
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() +  1) {
                                    onZoomOutAnimationComplete?()
                                }
                            }
                        }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }

    var body: some View {
        ZStack {
            if items.count == 0 {
                emptyGallery
            } else  {
                galleryItems
                    .padding()
            }
        }
    }
}
