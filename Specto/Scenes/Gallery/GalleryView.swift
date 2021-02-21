//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI
import Kingfisher



typealias NavDismissHandler = () -> Void

struct GalleryView: View {
    
    // View model controlling GalleryView state.
    @StateObject var viewModel = GalleryViewModel()
    
    @Namespace private var animation
    @State private var show: Bool = false
    
    // Our grid consists  of two equal size columns hence the .flexible() modifier.
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    //    init() {
    //        // Disable the default slide animation in navigation views.
    //        UINavigationBar.setAnimationsEnabled(false)
    //    }
    
    var content: some View {
        
        VStack {
            if let item =  viewModel.touchedOne {
                RecordItemView(item: item, zoomed: true)
                    
                    .onTapGesture {
                        
                        withAnimation(.spring()) {
                            viewModel.touchedOne = nil
                        }
                    }.matchedGeometryEffect(id: item.image, in: animation)
                    .frame(width: 250, height: 200)
            } else {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 50) {
                        ForEach(viewModel.items) { item in
                            
                            RecordItemView(item: item, zoomed: false)
                                
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        
                                        viewModel.touchedOne = item
                                    }
                                }.matchedGeometryEffect(id: item.image, in: animation)
                                .frame(width: 150, height: 100)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
            
        }
    }
    
    var body: some View {
        NavigationView {
            
            content
            
        }.hiddenNavigationBarStyle()
    }
    
    //    func onItemTouched(id: Int) {
    //        // Store the id of the touched item.
    //        viewModel.touchedOne = id
    //
    //        // Since one of the items is touched, it's display mode should be changed to fixed.
    //        //   Other ones should change to hidden.
    //        viewModel.items = viewModel.items.map {
    //            $0.id == id ? GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .activated, image: $0.image)
    //                        : GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .hidden, image: $0.image)
    //        }
    //    }
    //
    //    func onNavDismiss() {
    //        if viewModel.touchedOne == nil { return }
    //
    //        viewModel.items = viewModel.items.map {
    //            GalleryItem(id: $0.id, keywords: $0.keywords, displayMode: .fixed, image: $0.image)
    //        }
    //
    //        viewModel.touchedOne = nil
    //    }
    
    
    
    
}


struct RecordItemView: View {
    
    var item: GalleryItem
    var zoomed: Bool = false
    var frameWidth: CGFloat {zoomed ? 250 : 150}
    
    var frameHeight: CGFloat {zoomed ? 250 : 150}
    
    var alignment: Alignment = .center
    
    
    var body: some View {
        ZStack {
            
            if let image = item.image {
                KFImage(RecordingInteractor.getDocumentsDirectory().appendingPathComponent(image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    //.frame(width: frameWidth, height: frameHeight, alignment: alignment)
                    .offset(y: -50)
            }
            Rectangle()
                .fill(Color.green)
                //.frame(width: frameWidth, height: frameHeight - 35, alignment: alignment)
            
            VStack(alignment: .leading) {
                ForEach(item.keywords, id: \.self) { keyword in
                    
                    Text(keyword.uppercased()).font(.system(size: 16, weight: .regular, design: .serif))
                }
            }.offset(x: -20)
        }
    }
}
