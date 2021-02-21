import SwiftUI
import Kingfisher

struct RecordItemView: View {

    var image: String?
    var keywords: [String]
    
    var onPlay = false
    @State private var coverOffset: CGFloat = 0
    @State private var keywordsContainerOffset: CGFloat = 9999

    var recordImage: some View {
        ZStack {
            if let image = image {
                KFImage(RecordingInteractor.getDocumentsDirectory().appendingPathComponent(image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -50)
            } else {
                Image("GenericDisc")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -50)
            }
        }
    }

    var recordCover: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)

            VStack(alignment: .leading) {
                ForEach(keywords, id: \.self) { keyword in
                    Text(keyword.uppercased()).font(.system(size: 16, weight: .regular, design: .serif))
                }
            }.offset(x: -20)
        }
    }

    var largeKeywords: some View {
        HStack {
            Text(keywords[0])
            Text(keywords[1])
            Text(keywords[2])
        }
    }

    var body: some View {
        ZStack {
            if onPlay {
                recordImage
                recordCover
                    .onAppear {
                        withAnimation(.spring()) {
                            coverOffset = 9999
                        }
                    }
                    .offset(y: coverOffset)
                
                VStack {
                    Spacer()
                    largeKeywords
                        .onAppear {
                            withAnimation(.easeIn) {
                                keywordsContainerOffset = 50
                            }
                        }
                        .offset(y: keywordsContainerOffset)
                }

            } else {
                recordImage
                recordCover
            }
        }
    }
}
