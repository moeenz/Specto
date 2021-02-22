//
//  RootReducer.swift
//  Specto
//
//  Created by Moeen Zamani on 2/22/21.
//

import SwiftUI

enum RootDisplayMode {
    case grid
    case zoomIn
    case zoomOut
    case playing
}

class RootReducer: ObservableObject {

    @Published var nowPlaying: GalleryItem? = nil

    @Published var library: [GalleryItem] = []

    @Published var isEmpty: Bool = false
    
    @Published var displayMode: RootDisplayMode = .grid

    init() {

        let context = PersistenceController.init().container.viewContext

        if let result = RecordingInteractor(context).findAll() {
            library = result.enumerated().map { (index, element) in
                GalleryItem(id: index,
                            keywords: element.getKeywords(),
                            image: element.imagePath,
                            audio: element.filePath)
            }
        } else {
            isEmpty = true
        }
    }
}
