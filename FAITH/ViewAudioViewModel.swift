//
//  ViewAudioViewModel.swift
//  FAITH
//
//  Created by Guylian Bollon on 07/05/2021.
//

import Foundation
import AVFoundation


class ViewAudioViewModel: ObservableObject {
    var recording : Recording
    var audioPlayer : AVPlayer!
    @Published var isPlaying = false
    init(recording:Recording){
        self.recording = recording
    }
    func startPlayback(){
        let playbackSession = AVAudioSession.sharedInstance()
            if let filePath = self.recording.fileURL?.path, FileManager().fileExists(atPath: filePath) {
            do {
                try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                let playerItem = CachingPlayerItem.init(data: try Data(contentsOf: recording.fileURL!), mimeType: "audio/mpeg", fileExtension: ".mp3")
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer.play()
                isPlaying = true
            } catch {
                print("Playback failed.")
            }
            } else{
                print("The file does not exist at path || may not have been downloaded yet")
            }
    }
    func stopPlayback() {
        audioPlayer.pause()
        isPlaying = false
    }
}
