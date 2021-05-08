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
    var audioPlayer : AVAudioPlayer!
    @Published var isPlaying = false
    init(recording:Recording){
        self.recording = recording
    }
    func startPlayback(){
        let playbackSession = AVAudioSession.sharedInstance()
            if let filePath = self.recording.fileURL?.path, FileManager().fileExists(atPath: filePath) {
            do {
                try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                audioPlayer = try! AVAudioPlayer(contentsOf: recording.fileURL!)
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
        audioPlayer.stop()
        isPlaying = false
    }
}
