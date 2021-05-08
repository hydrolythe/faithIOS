//
//  BackpackView.swift
//  FAITH
//
//  Created by Guylian Bollon on 11/03/2021.
//

import SwiftUI

struct BackpackView: View {
    @ObservedObject var viewModel: BackpackViewModel
    @State var vlag: Bool = false
    @State var toevoegen: Bool = false
    let items = [
        GridItem(.adaptive(minimum: 80))
    ]
    var body: some View {
        HStack{
        ScrollView{
            LazyVGrid(columns: items, content: {
                ForEach(viewModel.details){ details in
                    BackpackItemView(detail: .constant(details), verwijderVlag: $vlag, viewModel: BackpackItemViewModel())
                }
            })
        }.background(Image("Backpack"))
            List{
                NavigationLink(
                    destination:Text("Destination"),
                    label: {
                        Image("bestandicoon")
                        Text("Bestand toevoegen")
                    })
                NavigationLink(
                    destination: PhotoView(),
                    label: {
                        Image("Fotoicoon")
                        Text("Foto nemen")
                    })
                NavigationLink(
                    destination: DrawingView(drawingViewModel: DrawingViewModel()),
                    label: {
                        Image("Tekentoevoegicoon")
                        Text("Tekenen")
                    })
                NavigationLink(
                    destination:Text("Destination"),
                    label: {
                        Image("Teksttoevoegicoon")
                        Text("Schrijven")
                    })
                NavigationLink(
                    destination:AudioView(audioRecorder: AudioRecorder()),
                    label: {
                        Image("Audiotoevoegicoon")
                        Text("Inspreken")
                    })
                NavigationLink(
                    destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                    label: {
                        Image("Filmtoevoegicoon")
                        Text("Filmen")
                    })
            }
        }
    }
}

struct BackpackView_Previews: PreviewProvider {
    static var previews: some View {
        BackpackView(viewModel:BackpackViewModel())
    }
}
