//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

typealias NavDismissHandler = () -> Void

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
                                    navDismissHandler: onNavDismiss)
                }
            }
            .padding(.horizontal)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                content
                VStack {
                    Spacer()
                    Text("Gallery View")
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

    func onNavDismiss() {
        if viewModel.touchedOne == nil { return }

        viewModel.items = viewModel.items.map {
            GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .fixed)
        }

        viewModel.touchedOne = nil
    }
}
