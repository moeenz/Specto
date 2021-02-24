//
//  AppModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/24/21.
//

import SwiftUI

class AppModel: ObservableObject {

    @Published var shouldDisplayInfoView: Bool = {
        UserDefaults.standard.value(forKey: "App.shouldDisplayInfoView") as? Bool != false
    }()

    @Published var nowPlaying: GalleryItem? = nil

    @Published var library: [GalleryItem] = []

    @Published var visibleScene: AppVisibleScene = .gallery

    private let coverFontDesignOptions: [Font.Design] = [.default, .monospaced, .rounded, .serif]
    private let coverFontWeightOptions: [Font.Weight] = [.heavy, .ultraLight, .medium, .ultraLight]
    private let coverColorOptions: [Color] = [.red, .orange, .yellow, .purple,
                                              .green, .pink, .blue,
                                              .red, .orange, .yellow, .purple]

    init() {
        refreshLibrary()
    }

    func refreshLibrary() {
        let context = PersistenceController.init().container.viewContext

        if let result = RecordingInteractor(context).findAll() {
            library = result.enumerated().map { (index, element) in
                GalleryItem(id: index,
                            keywords: element.getCleanKeywords(),
                            image: element.imagePath,
                            audio: element.filePath,
                            coverFont: .system(size: 24,
                                               weight: coverFontWeightOptions.randomElement() ?? .regular,
                                               design: coverFontDesignOptions.randomElement() ?? .default),
                            coverColor: coverColorOptions.randomElement() ?? .green)
            }
        }
    }

    func infoViewDisplayed() {
        UserDefaults.standard.setValue(false, forKey: "App.shouldDisplayInfoView")
        shouldDisplayInfoView = false
    }

    func onGalleryItemSelected(_ item: GalleryItem) {
        nowPlaying = item
        visibleScene = .recordZoomIn
    }

    func onPlayFinished() {
        visibleScene = .recordZoomOut
    }

    func onShrinkAnimationComplete() {
        nowPlaying = nil
    }

    func onZoomInAnimationComplete() {
        visibleScene = .recordPlaying
    }

    func onZoomOutAnimationStarted() {
        visibleScene = .gallery
    }

    func onZoomOutAnimationComplete() {
        visibleScene = .gallery
        nowPlaying = nil
    }
}
