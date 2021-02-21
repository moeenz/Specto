//
//  GalleryTransitionView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/20/21.
//

import SwiftUI

///
fileprivate enum TransitionDirection {
    case toCenter
    case backInPlace
}

/// GalleryTransitionView quickly replaces the GalleryView with the selected item position exactly
///   where it originally was. Then it's moved to center of screen and PlayView is shown. When
///   we're done with PlayView we will apply the backInPlace transition which moves brings the
///   item back to its original place.
struct GalleryTransitionView<Content: View>: View {

    var navDismissHandler: NavDismissHandler?

    /// This value holds the original X-coordinate of the item in global frame.
    var itemOriginX: CGFloat
    /// This value holds the original Y-coordinate of the item in global frame.
    var itemOriginY: CGFloat
    /// The actual view object to move.
    var itemView: Content

    /// We use this Environment field to modify presentation status.
    @Environment(\.presentationMode) var presentation

    /// In order to programmatically fire navigation links we need this boolean flag to toggled at the right moment.
    @State private var pushNavigationLink: Bool = false

    @State private var direction: TransitionDirection
    
    /// Current X-coordinate value is held as a state field to control animation updates.
    @State var currentX: CGFloat
    /// Current Y-coordinate value is held as a state field to control animation updates.
    @State var currentY: CGFloat
    /// Current alignment value is held as a state field to control animation updates. We will
    ///   switch between alignments since object is positioned differently at each stage.
    @State var currentAlignment: Alignment
    
    // Configuration values for animations.
    private let animationLength: Double = 0.75
    private let animation: Animation = .linear(duration: 0.75)

    init(itemOriginX: CGFloat,
         itemOriginY: CGFloat,
         @ViewBuilder itemView: () -> Content,
         navDismissHandler: NavDismissHandler? = nil) {

        self.itemOriginX = itemOriginX
        self.itemOriginY = itemOriginY
        self.itemView = itemView()
        self.navDismissHandler = navDismissHandler
        
        self._direction = State(initialValue: .toCenter)
        self._currentX = State(initialValue: itemOriginX)
        self._currentY = State(initialValue: itemOriginY)
        self._currentAlignment = State(initialValue: .topLeading)
    }

    var body: some View {
        VStack {
            HStack {
                // We used a NavigationLink here because we need to push onto to the
                //  navigation stack once the animation is finished.
//                NavigationLink(
//                    destination: LazyView(PlayView(navDismissHandler: onNavDismiss)),
//                    isActive: $pushNavigationLink,
//                    label: {
//                        itemView
//                            .onAppear {
//                                withAnimation(animation) {
//                                    switch direction {
//                                    // This part executes when we're coming from GalleryView and want to move
//                                    //  the item to the center of screen.
//                                    case .toCenter:
//                                        currentAlignment = .center
//                                        currentX = 0
//                                        currentY = 0
//                                    // This part executes when we're back from PlayView and want to put back
//                                    //  the item to its original place.
//                                    case .backInPlace:
//                                        currentAlignment = .topLeading
//                                        currentX = itemOriginX
//                                        currentY = itemOriginY
//                                    }
//                                }
//
//                                // Once the animation is done we push forward or backward on the navigation
//                                //  stack based on the direction state.
//                                DispatchQueue.main.asyncAfter(deadline: .now() + animationLength) {
//                                    if direction == .toCenter {
//                                        pushNavigationLink = true
//                                    }
//                                }
//                            }
//                    }
//                )
            }
            .frame(maxWidth: .infinity, alignment: currentAlignment)  // Filling the entire screen width.
            .padding(EdgeInsets(top: 0, leading: currentX, bottom: 0, trailing: 0))
        }
        .frame(maxHeight: .infinity, alignment: currentAlignment)  // Filling the entire screen height.
        .padding(EdgeInsets(top: currentY, leading: 0, bottom: 0, trailing: 0))
        .hiddenNavigationBarStyle()
    }
    
    func onNavDismiss() {
        pushNavigationLink = false
        direction = .backInPlace
        DispatchQueue.main.asyncAfter(deadline: .now() + animationLength) {
            navDismissHandler?()
        }
    }
}
