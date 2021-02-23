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
    
    private let coverFontDesignOptions: [Font.Design] = [.default, .monospaced, .rounded, .serif]
    private let coverFontWeightOptions: [Font.Weight] = [.heavy, .ultraLight, .medium, .ultraLight]
    private let coverColorOptions: [Color] = [.red, .orange, .yellow, .purple,
                                              .green, .pink, .blue,
                                              .red, .orange, .yellow, .purple]

    init() {
        let context = PersistenceController.init().container.viewContext

        if let result = RecordingInteractor(context).findAll() {
            if result.count == 0 {
                isEmpty = true
                return
            }

            library = result.enumerated().map { (index, element) in
                GalleryItem(id: index,
                            keywords: getCleanKeywords(for: element),
                            image: element.imagePath,
                            audio: element.filePath,
                            coverFont: .system(size: 24,
                                               weight: coverFontWeightOptions.randomElement() ?? .regular,
                                               design: coverFontDesignOptions.randomElement() ?? .default),
                            coverColor: coverColorOptions.randomElement() ?? .green)
            }
        }
    }
    
    private func getCleanKeywords(for recording: Recording) -> [String] {
        let processedKeywords = recording.getKeywords()

        if processedKeywords == [] || processedKeywords ==  [""] {
            return ["No", "Context", "Detected"]
        }

        return processedKeywords
    }
}
