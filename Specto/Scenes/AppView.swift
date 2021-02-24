//
//  ContentView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        if appModel.shouldDisplayInfoView {
            InfoView(viewModel: InfoViewModel(onDismissHandler: appModel.infoViewDisplayed))
        } else {
            RootView(viewModel: RootViewModel())
                .environmentObject(appModel)
        }
    }
}
