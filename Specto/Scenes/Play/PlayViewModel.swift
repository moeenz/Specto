//
//  PlayViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import Foundation
import AVKit

class PlayViewModel: NSObject, ObservableObject {
    
    @Published var isPlaying = true
    
    var onPlayFinishHandler: (() -> Void)?

    private var player: AVAudioPlayer? = nil
    
    private let audioSession = AVAudioSession.sharedInstance()

    func play(item: GalleryItem, onPlayFinishHandler: (() -> Void)?) {
        self.onPlayFinishHandler = onPlayFinishHandler

        let url = RecordingInteractor.getDocumentsDirectory().appendingPathComponent(item.audio!)

        do {
            try audioSession.setCategory(.playback)
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
        } catch _{
            return
        }
    }
}

extension PlayViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.stop()
        self.player = nil

        isPlaying = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.onPlayFinishHandler?()
        }
    }
}
