//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct GalleryView: View {

    // View model controlling GalleryView state.
    @StateObject var viewModel = GalleryViewModel()

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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.items) { item in
                    GalleryItemView(coverColor: Color.red,
                                    contentItem: item,
                                    touchHandler: onItemTouched,
                                    displayMode: item.displayMode)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        NavigationView {
            content
                .onDisappear {
                    if viewModel.touchedOne == nil { return }
                    
                    // Same as GalleryTransitionView, we have to change items state when this
                    //  view disappears and put a little delay for it to not mess with the UI.
                    //  There should be a better way of course but we couldn't find it.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.items = viewModel.items.map {
                            $0.id == viewModel.touchedOne
                                ? GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .activated)
                                : GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .hidden)
                        }
                        // Set this one to nil so it won't clash next time.
                        viewModel.touchedOne = nil
                    }
                }
        }.hiddenNavigationBarStyle()
    }
    
    func onItemTouched(id: Int) {
        // Store the id of the touched item.
        viewModel.touchedOne = id
        
        // Since one of the items is touched, it's display mode should be changed to fixed.
        //   Other ones should change to hidden.
        viewModel.items = viewModel.items.map {
            $0.id == id ? GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .activated)
                        : GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .hidden)
        }
    }
}
