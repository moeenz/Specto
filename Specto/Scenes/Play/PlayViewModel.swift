//
//  PlayViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import Foundation
import AVKit

final class PlayViewModel: NSObject, ObservableObject {
    
    var onPlayFinishHandler: (() -> Void)?
    @Published var isPlaying = true
    
    var player: AVAudioPlayer? = nil
    
    func play(item: GalleryItem, onPlayFinishHandler: (() -> Void)?) {
        
        self.onPlayFinishHandler = onPlayFinishHandler

        let url = RecordingInteractor.getDocumentsDirectory().appendingPathComponent(item.audio!)
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.onPlayFinishHandler?()
            }
    }
}


