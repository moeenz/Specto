//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct GalleryView: View {

    init() {
        let context = PersistenceController.init().container.viewContext
        let recordings = RecordingInteractor(context).findAll()
        recordings?.forEach { item in
            // List if all recordings
            print(item.keywords)
        }
    }

    var body: some View {
        Text("Gallery View")
            .padding()
    }
}
