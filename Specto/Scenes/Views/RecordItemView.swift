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
    @State private var coverOffset: CGFloat = 0
    @State private var keywordsContainerOffset: CGFloat = 9999

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
            Text(keywords[0])
            Text(keywords[1])
            Text(keywords[2])
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
                        coverOffset = 9999
                    }
                    .offset(y: coverOffset)

                VStack {
                    Spacer()
                    largeKeywords
                        .animate {
                            keywordsContainerOffset = 150
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
                            keywordsContainerOffset = 9999
                        }
                        .offset(y: keywordsContainerOffset)
                }
            }
        }
    }
}

extension View {
    func animate(using animation: Animation = Animation.easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

