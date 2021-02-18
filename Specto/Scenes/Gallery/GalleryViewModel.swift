//
//  GalleryViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import Foundation

class GalleryViewModel: ObservableObject {

    @Published var recordings = [Recording]()

    init() {
        let context = PersistenceController.init().container.viewContext
        if let result = RecordingInteractor(context).findAll() {
            recordings = result
        }
    }
}
