//
//  GalleryViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

class GalleryViewModel: ObservableObject {

    @Published var items: [GalleryItem] = []

    @Published var touchedOne: GalleryItem? = nil

    init() {

        let context = PersistenceController.init().container.viewContext

        if let result = RecordingInteractor(context).findAll() {
            items = result.enumerated().map { (index, element) in
                GalleryItem(id: index, keywords: element.getKeywords(), displayMode: .fixed, image: element.imagePath)
            }
        }
    }
}
