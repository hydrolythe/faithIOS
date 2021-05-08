//
//  ContentView.swift
//  FAITH
//
//  Created by Guylian Bollon on 09/03/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        HStack{
            Image("Loginvriendjes")
            if(viewModel.content == nil || viewModel.content?.resourceState == ResourceState.ERROR){
            VStack{
                Text("Welkom in LIFECITY").font(.title)
                VStack{
                    Text("Gebruikersnaam")
                        .font(.subheadline)
                    HStack{
                        Image("Gebruikericoon")
                        TextField("Typ hier je gebruikersnaam", text: $username).cornerRadius(30)
                    }
                    Text("Wachtwoord")
                        .font(.subheadline)
                    HStack{
                        Image("Wachtwoordicoon")
                        SecureField("Typ hier je wachtwoord", text: $password).cornerRadius(30)
                    }
                    Button(action:{ viewModel.login(user:User(username: username, password: password))}
                           , label: {
                        HStack{
                            Image("Stadicoon")
                            Text("Naar de stad")
                        }
                    }).cornerRadius(40)
                }.background(RoundedRectangle(cornerRadius: 30,style: .continuous).fill(Color.white))
                HStack{
                    Image("Ster")
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Ik ben nieuw")
                    }).cornerRadius(30)
                    Image("Ster")
                }
            }
            }
            if(viewModel.content?.resourceState == ResourceState.LOADING){
                       Image("Laadicoon")
                   }
            if(viewModel.content?.resourceState == ResourceState.SUCCESS){
                NavigationLink(destination:BackpackView(viewModel: BackpackViewModel())){
                    Text("Ga hier naar de backpack")
                }
            }
        }.background(
            Image("Loginbackground")
            .padding()
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
