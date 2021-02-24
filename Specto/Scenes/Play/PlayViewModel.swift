//
//  PlayViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import AVKit

class PlayViewModel: NSObject, ObservableObject {

    @Published var isPlaying = true
    @Published var playbackFailed = false
    @Published var largeKeywordsOffset: CGFloat = -500

    var item: GalleryItem

    var onPlayFinishedHandler: (() -> Void)?

    private var player: AVAudioPlayer? = nil

    private let audioSession = AVAudioSession.sharedInstance()

    init(item: GalleryItem, onPlayFinishedHandler: (() -> Void)?) {
        self.item = item
        self.onPlayFinishedHandler = onPlayFinishedHandler
    }

    func play() {
        let url = RecordingInteractor.getDocumentsDirectory().appendingPathComponent(item.audio!)

        do {
            try audioSession.setCategory(.playback)
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
        } catch {
            playbackFailed = true
        }
    }

    func pushUpKeywords() {
        largeKeywordsOffset = -500
    }

    func bringDownKeywords() {
        largeKeywordsOffset = 40
    }
}

extension PlayViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.stop()
        self.player = nil

        isPlaying = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.onPlayFinishedHandler?()
        }
    }
}
