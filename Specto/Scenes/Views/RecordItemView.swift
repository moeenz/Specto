import SwiftUI
import Kingfisher

enum RecordDisplayMode {
    case fixed
    case startPlaying
    case finishPlaying
}

struct RecordItemView: View {

    var image: String?
    var keywords: [String]
    
    var onPlay = false
    @State var coverOffset: CGFloat = 0
    @State var keywordsContainerOffset: CGFloat = UIScreen.main.bounds.maxY
    
    private let abyss: CGFloat = UIScreen.main.bounds.maxY

    @State var displayMode: RecordDisplayMode = .fixed

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
            
            ForEach(keywords, id: \.self) {keyword in
                Text(keyword)
            }
        }
    }

    var body: some View {
        ZStack {
            switch displayMode {
            case .fixed:
                recordImage
                recordCover
            case .startPlaying:
                recordImage
                recordCover
                    .animate {
                        coverOffset = abyss
                    }
                    .offset(y: coverOffset)

                VStack {
                    Spacer()
                    largeKeywords
                        .animate(using: .spring()) {
                            keywordsContainerOffset = 200
                        }
                        .offset(y: keywordsContainerOffset)
                }
            case .finishPlaying:
                recordImage
                recordCover
                    .animate {
                        coverOffset = 0
                    }
                    .offset(y: coverOffset)

                VStack {
                    Spacer()
                    largeKeywords
                        .animate {
                            keywordsContainerOffset = abyss
                        }
                        .offset(y: keywordsContainerOffset)
                }
            }
        }
    }
}
