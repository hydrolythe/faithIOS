//
//  BackpackItemView.swift
//  FAITH
//
//  Created by Guylian Bollon on 14/03/2021.
//

import SwiftUI

struct BackpackItemView: View {
    @Binding var detail: ExpandedDetail
    @Binding var verwijderVlag: Bool
    @ObservedObject var viewModel: BackpackItemViewModel
    
    var body: some View {
        VStack{
            if(verwijderVlag == true){
                Button(action: {
                    print("Edit button was tapped")
                }){
                    Image("Verwijdericoon").offset(x:35,y:15)
                }
            }
            switch(detail.detailType){
            case "AUDIO" : NavigationLink(destination:ViewAudioView(audioRecorder:ViewAudioViewModel(recording: viewModel.getResource(detail: detail))), label:{
                Image("Audioicoon")
            })            
            case "DRAWING": NavigationLink(destination:ViewDrawingView(recording:viewModel.getResource(detail:detail))){
                    Image(uiImage: UIImage(data:Data(base64Encoded: detail.thumbnail ?? "", options: Data.Base64DecodingOptions.ignoreUnknownCharacters) ?? Data()) ?? UIImage())
                }
            case "PHOTO" : NavigationLink(destination:ViewDrawingView(recording:viewModel.getResource(detail:detail))){                Image(uiImage: UIImage(data:Data(base64Encoded: detail.thumbnail ?? "", options: Data.Base64DecodingOptions.ignoreUnknownCharacters) ?? Data()) ?? UIImage())
            }
            case "TEXT" : Image("Texticoon")
            default:
                Text("Nothing to show")
            }
            Text(detail.title)
        }
    }
}

struct BackpackItemView_Previews: PreviewProvider {
    static var previews: some View {
        BackpackItemView(detail: .constant(ExpandedDetail.detail),verwijderVlag: .constant(true),viewModel:BackpackItemViewModel())
            .previewLayout(.fixed(width:90,height:150))
    }
}
