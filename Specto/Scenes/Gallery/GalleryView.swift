//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Kingfisher

typealias NavDismissHandler = () -> Void

struct GalleryView: View {
    
    // View model controlling GalleryView state.
    @StateObject var viewModel = GalleryViewModel()
    
    @Namespace private var animation
    @State private var show: Bool = false
    
    @State private var pushLink = false
    
    // Our grid consists  of two equal size columns hence the .flexible() modifier.
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        // Disable the default slide animation in navigation views.
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var content: some View {
        ZStack {
            if let item = viewModel.touchedOne {
                RecordItemView(image: item.image,
                               keywords: item.keywords,
                               displayMode: .fixed)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.touchedOne = nil
                        }
                    }.matchedGeometryEffect(id: String(item.id), in: animation)
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
                if let touchedOne = viewModel.touchedOne {
                    NavigationLink(
                        destination: PlayView(item: touchedOne, playFinishHandler: onPlayFinished),
                        isActive: $pushLink,
                        label: {
                            EmptyView()
                        }
                    )
                }
                content
            }
        }
    }
}
