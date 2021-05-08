//
//  AudioView.swift
//  FAITH
//
//  Created by Guylian Bollon on 27/03/2021.
//

import SwiftUI

struct AudioView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State var timeRecording = 0
    @State var minutesRecording = 0
    @State var isPaused = false
    @State var selection: Int? = nil
    @State var recordPhase = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack{
            if(recordPhase==0){
                Text("Druk op de rode bol om het geluidsfragment op te nemen.")
                Button(action:{
                    audioRecorder.startRecording()
                    recordPhase = 1
                }, label: {
                    Circle().fill(Color.red).frame(width: 70, height: 70, alignment: .center)
                })
            }
            if(recordPhase==1){
                Text("\(minutesRecording):\(timeRecording)").onReceive(timer){ _ in
                    if(!isPaused){
                        if(timeRecording<60){
                            timeRecording += 1
                        }
                        if(timeRecording==60){
                            timeRecording = 0
                            minutesRecording += 1
                        }
                    }
                }
                HStack{
                    Button(action:{
                        audioRecorder.stopRecording()
                        recordPhase = 2
                    }, label: {
                        Image(systemName:"stop.fill")
                    })
                    Button(action: {
                        if(!isPaused){
                            audioRecorder.pauseRecording()
                        }
                        if(isPaused){
                            audioRecorder.unpauseRecording()
                        }
                        isPaused = !isPaused
                    }, label: {
                        Image(systemName:"pause.fill")
                    })
                }
            }
            if(recordPhase == 2){
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
                    Button(action:{
                        audioRecorder.removeRecording()
                    }, label: {
                        Image("vuilbakvolicoon")
                    })
                    NavigationLink(
                        destination:SaveView(recording: audioRecorder.recording,contentType: DetailType.AUDIO),
                        label: {
                            Image("opslagicoon")
                        })
                }
            }
            Image("avataricoon")
        }
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView(audioRecorder: AudioRecorder())
    }
}
