import SwiftUI
import Kingfisher

enum RecordDisplayMode {
    case fixed
    case startPlaying
    case finishPlaying
}

struct RecordItemView: View {

    private let downwardAbyss: CGFloat = UIScreen.main.bounds.maxY
    private let upwardAbyss: CGFloat = UIScreen.main.bounds.minY

    var coverColor: Color = .green
    var coverFont: Font = .system(size: 20, weight: .heavy, design: .default)
    var image: String?
    var keywords: [String]

    private var animation: Animation {
        Animation
            
            .linear(duration: 7.5)
            .repeatForever(autoreverses: false)
    }

    @State var coverOffset: CGFloat = 0
    @State var displayMode: RecordDisplayMode = .fixed
    @State var rotateFactor = Angle(radians: 0)

    var recordImage: some View {
        ZStack {
            if let image = image {
                KFImage(RecordingInteractor.getDocumentsDirectory().appendingPathComponent(image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("GenericDisc")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }

    var recordCover: some View {
        ZStack {
            RoundedRectangle.init(cornerRadius: 5)
                .fill(coverColor)

            VStack(alignment: .leading) {
                ForEach(keywords, id: \.self) { keyword in
                    Text(keyword.uppercased())
                        .font(coverFont)
                        .foregroundColor(Color.black)
                        .frame(maxHeight: .infinity)
                        .lineLimit(1)
                        .allowsTightening(true)
                        .minimumScaleFactor(0.01)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .offset(y: 50)
    }

    var body: some View {
        ZStack {
            switch displayMode {
            case .fixed:
                recordImage
                recordCover
            case .startPlaying:
                recordImage
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(animation) {
                                rotateFactor = Angle(radians: 2 * Double.pi)
                            }
                        }
                    }
                    .rotationEffect(rotateFactor)
                recordCover
                    .animate {
                        coverOffset = downwardAbyss
                    }
                    .offset(y: coverOffset)
            case .finishPlaying:
                recordImage
                recordCover
                    .animate {
                        coverOffset = 0
                    }
                    .offset(y: coverOffset)
            }
        }
    }
}
