//
//  ViewAudioView.swift
//  FAITH
//
//  Created by Guylian Bollon on 07/05/2021.
//

import SwiftUI

struct ViewAudioView: View {
    @ObservedObject var audioRecorder: ViewAudioViewModel
    var body: some View {
        VStack{
        Image("geluidicoon")
        HStack{
            if(audioRecorder.isPlaying==false){
                Button(action:{
                    audioRecorder.startPlayback()
                }, label: {
                    Image(systemName: "play.fill").frame(width:29,height:40,alignment: .center)
                })
            } else{
                Button(action:{
                    audioRecorder.stopPlayback()
                }, label: {
                    Image(systemName: "stop.fill").frame(width:29,height:40,alignment: .center)
                })
            }
        }
            Image("avataricoon")
        }
    }
}

struct ViewAudioView_Previews: PreviewProvider {
    static var previews: some View {
        ViewAudioView(audioRecorder: ViewAudioViewModel(recording: Recording(fileURL: nil, createdAt: nil)))
    }
}
