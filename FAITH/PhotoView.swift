//
//  PhotoView.swift
//  FAITH
//
//  Created by Guylian Bollon on 26/03/2021.
//

import SwiftUI

struct PhotoView: View {
    @State var recording = Recording(fileURL: nil, createdAt: nil)
    @State var uiimage: UIImage = UIImage()
    @State var showCaptureImageView: Bool = false
    @ObservedObject var viewModel = PhotoViewModel()
    var body: some View {
            HStack{
                if(recording.fileURL==nil){
                Button(action:{
                    uiimage = UIImage()
                }, label: {
                    Image("vuilbakvolicoon")
                }).disabled(self.uiimage==UIImage())
                    Image(uiImage: uiimage).resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 4))
                    .cornerRadius(30)
                    CaptureImageView(isShown: $showCaptureImageView,
                                        image: $uiimage)
                VStack{
                    if(uiimage != UIImage()){
                        Button(action:{
                            recording = viewModel.saveImage(imageName:Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss).jpeg"), image: uiimage)
                        }, label: {
                            Image("opslagicoon")
                        })
                    }
                    Button(action:{
                        self.showCaptureImageView.toggle()
                    }, label: {
                        Image("fotoneemicoon")
                    })
                    Button(action:{
                        
                    }, label: {
                        Image("Cameradraaiicoon")
                    })
                }
        }
                else{
                    NavigationLink(
                        destination: SaveView(recording: recording, contentType: DetailType.DRAWING),
                        label: {
                            Image("opslagicoon")
                        })
                }
        }.background(Color.yellow)
    }
    
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}


