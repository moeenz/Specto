//
//  GalleryViewItem.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

/// Callback closure to be executed upon clicking on each item in fixed state which leads to activated state.
typealias GalleryItemTouched = (Int) -> Void

/// Display mode controls how each item in GalleryView grid is displayed at each stage of transition animation.
enum GalleryItemDisplayMode {
    /// Fixed mode is when items are displayed first without any animation.
    case fixed
    /// Hidden mode is when some other item is activated and all others must hide for incoming transition.
    case hidden
    /// Exposed mode is when we're back to GalleryView and we shoud undo hidden items.
    case exposed
    /// Activated mode is when an item is touched and it should be played
    case activated
}

// TODO: make this class!
/// Tiny view model for GalleryItemView view below.
struct GalleryItem: Identifiable, Hashable {
    let id: Int
    let keywords: [String]
    let displayMode: GalleryItemDisplayMode
}

struct GalleryItemView: View {

    var coverColor: Color

    var contentItem: GalleryItem

    var touchHandler: GalleryItemTouched?

    /// Display mode changes by the parent to toggle between view states.
    @State var displayMode: GalleryItemDisplayMode
    /// X-coordinate is saved for reporting to transition view since this is the location it will be left off.
    @State private var xPosition: CGFloat = 0
    /// Y-coordinate is saved for reporting to transition view since this is the location it will be left off.
    @State private var yPosition: CGFloat = 0
    /// Opacity level is controlled for hiding/exposing animation.
    @State private var opacityLevel: Double = 1
    /// In order to programmatically fire navigation links we need this boolean flag to toggled at the right moment.
    @State private var pushNavigationLink: Bool = false

    // Configuration values for each item shape.
    private let frameWidth: CGFloat = 100
    private let frameHeight: CGFloat = 100
    private let alignment: Alignment = .center

    // Configuration values for animations.
    private let animationLength: Double = 0.5
    private let animation: Animation = .linear(duration: 0.5)

    func buildRecordItemView() -> RecordItemView {
        return RecordItemView(frameWidth: frameWidth,
                                frameHeight: frameHeight,
                                alignment: alignment)
    }

    var body: some View {
        switch displayMode {
        case .fixed:
            Button(
                action: {
                    displayMode = .activated
                    touchHandler?(contentItem.id)
                }, label: {
                    buildRecordItemView()
                }
            )
        case .activated:
            NavigationLink(
                destination: GalleryTransitionView<RecordItemView>(itemOriginX: xPosition,
                                                   itemOriginY: yPosition,
                                                   itemView: buildRecordItemView),
                isActive: $pushNavigationLink,
                label: {
                    // The GeometryReader should also be framed the same as the underlying
                    //  view, otherwise it will mess with its bounds. You can read more about
                    // it here: https://swiftwithmajid.com/2020/11/04/how-to-use-geometryreader-without-breaking-swiftui-layout/
                    GeometryReader { proxy in
                        buildRecordItemView()
                            .onAppear {
                                // GeometryReader allows us to get the object position inside a desired frame.
                                // We're getting the global frame because this view will be drawn in the
                                //  GalleryTransitionView again and they should overlap to avoid glitches.
                                let frame = proxy.frame(in: .global)
                                
                                xPosition = frame.origin.x
                                yPosition = frame.origin.y - frame.height / 2
                                
                                // We push to GalleryTransitionView after the hiding animation is complete.
                                //  This approach is taken since we couldn't find a completion handler like
                                //  the one in UIKit animations.
                                DispatchQueue.main.asyncAfter(deadline: .now() + animationLength) {
                                    pushNavigationLink = true
                                }
                            }
                    }.frame(width: frameWidth, height: frameHeight, alignment: alignment)
                }
            )
        case .hidden:
            buildRecordItemView()
                .opacity(opacityLevel)
                .onAppear {
                    withAnimation(animation) {
                        opacityLevel = 0
                    }
                }
        case .exposed:
            buildRecordItemView()
                .opacity(opacityLevel)
                .onAppear {
                    withAnimation(animation) {
                        opacityLevel = 1
                    }
                }
        }
    }
}
