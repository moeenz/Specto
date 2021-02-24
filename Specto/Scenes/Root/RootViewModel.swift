//
//  RootViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/24/21.
//

import SwiftUI

class RootViewModel: ObservableObject {
    @Published var isRecordSheetOpen = false

    func recordButtonTouched() {
        isRecordSheetOpen.toggle()
    }
}
