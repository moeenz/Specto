//
//  InfoViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/24/21.
//

import SwiftUI

class InfoViewModel: ObservableObject {
    var onDismissHandler: (() -> Void)?

    init(onDismissHandler: (() -> Void)?) {
        self.onDismissHandler = onDismissHandler
    }
}
