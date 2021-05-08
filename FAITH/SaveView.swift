//
//  SaveView.swift
//  FAITH
//
//  Created by Guylian Bollon on 23/04/2021.
//

import SwiftUI

struct SaveView: View {
    var recording: Recording
    var contentType: DetailType
    let dateFormatter: DateFormatter
    @ObservedObject var saveViewModel: SaveViewModel
    @State var title: String = ""
    @State var notities: String = ""
    init(recording:Recording,contentType:DetailType){
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y"
        self.contentType = contentType
        self.recording = recording
        self.saveViewModel = SaveViewModel(recording:recording,type:contentType)
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        HStack{
            Image("Schildericoon")
            VStack(alignment: .leading, spacing: nil, content: {
                HStack{
                    Image("Kalender")
                    Text(recording.createdAt!, formatter:dateFormatter)
                }.background(Color.white)
                Text("Je werkje opslaan").font(.title)
                Text("Titel").font(.subheadline)
                HStack{
                    Image("Boekicoon")
                    TextField("Typ hier de titel van je werkje",text:$title).cornerRadius(30)
                }
                Button(action:{
                    saveViewModel.saveItem(title:title)
                    self.presentationMode.wrappedValue.dismiss()
                    self.presentationMode.wrappedValue.dismiss()
                }
                , label: {
                    Image("opslagicoon")
                    Text("Opslaan")
                })
            }).background(Color.green)
        }
    }
}

struct SaveView_Previews: PreviewProvider {
    static var previews: some View {
        SaveView(recording: Recording(fileURL: nil, createdAt: nil), contentType: DetailType.AUDIO)
    }
}
