//
//  DrawingView.swift
//  FAITH
//
//  Created by Guylian Bollon on 24/03/2021.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @State private var color: Color = Color.gray
    @State private var lineWidth: CGFloat = 25.0
    @State private var currentDrawing: Drawing = Drawing()
    @State private var drawings: [Drawing] = [Drawing]()
    @ObservedObject var drawingViewModel: DrawingViewModel
    @State var recording = Recording(fileURL: nil, createdAt: nil)
    @State var backgroundImage = UIImage()
    var body: some View {
        HStack{
            if(recording.fileURL==nil){
                VStack{
                VStack{
                    HStack{
                        if(color==Color.green){
                            Image("Pijl")
                        }
                        Button(action:{
                            color = Color.green
                        }, label: {
                            Image("verfgroen")
                        })
                    }
                    HStack{
                        if(color==Color.blue){
                            Image("Pijl")
                        }
                        Button(action:{
                            color = Color.blue
                        }, label: {
                            Image("verfblauw")
                        })
                    }
                    HStack{
                        if(color==Color.red){
                            Image("Pijl")
                        }
                        Button(action:{
                            color = Color.red
                        }, label: {
                            Image("verfrood")
                        })
                    }
                    HStack{
                        if(color==Color.yellow){
                            Image("Pijl")
                        }
                        Button(action:{
                            color = Color.yellow
                        }, label: {
                            Image("verfgeel")
                        })
                    }
                    HStack{
                        if(color==Color.gray){
                            Image("Pijl")
                        }
                        Button(action:{
                            color = Color.gray
                        }, label: {
                            Image("verfgrijs")
                        })
                    }
                    Divider()
                    HStack{
                        if(color != Color.green && color != Color.blue && color != Color.red && color != Color.yellow && color != Color.gray){
                            Image("Pijl")
                        }
                        ColorPicker(selection: $color, label: {
                            Image("verfmulti")
                        })
                    }
                }.background(Color.white).border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(20)
                    VStack{
                        Menu("Penceelgrootte", content:{
                            Button(action:{
                                lineWidth = 40.0
                            },
                            label: {
                                Circle().fill(Color.green).frame(width:40,height:40)
                            })
                            Button(action:{
                                lineWidth = 25.0
                            },
                            label: {
                                Circle().fill(Color.green).frame(width:25,height:25)
                            })
                            Button(action:{
                                lineWidth = 15.0
                            },
                            label: {
                                Circle().fill(Color.green).frame(width:15,height:15)
                            })
                        })
                        Button(action:{
                            if self.drawings.count > 0{
                                self.drawings.removeLast()
                            }
                        }, label: {
                            Image("Returnicoon")
                        })
                    }.background(Color.white).border(Color.black, width: 1).cornerRadius(20)
            }
                GeometryReader { geometry in
                        Path { path in
                            for drawing in self.drawings {
                                self.add(drawing: drawing, toPath: &path)
                            }
                            self.add(drawing: self.currentDrawing, toPath: &path)
                        }
                        .stroke(self.color, lineWidth: self.lineWidth)
                        .background(Image(uiImage: backgroundImage))
                        .background(Color(white: 0.95))
                            .gesture(
                                DragGesture(minimumDistance: 0.1)
                                    .onChanged({ (value) in
                                        let currentPoint = value.location
                                        if currentPoint.y >= 0
                                            && currentPoint.y < geometry.size.height {
                                            self.currentDrawing.points.append(currentPoint)
                                        }
                                    })
                                    .onEnded({ (value) in
                                        self.drawings.append(self.currentDrawing)
                                        self.currentDrawing = Drawing()
                                    })
                            )
                    }
                .frame(maxHeight: .infinity).cornerRadius(60)
                Button(action:{
                    backgroundImage = UIImage(systemName: "play.fill") ?? UIImage()
                }, label: {
                        Image(systemName: "play.fill").frame(width:29,height:40,alignment: .center)
                    
                })
                Button(action:{
                    recording = drawingViewModel.saveImage(drawings:drawings, imageName:Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss).jpeg"))
                }
                , label: {
                    Image("opslagicoon")
                })
            }
            else{
                NavigationLink(
                    destination: SaveView(recording: recording, contentType: DetailType.DRAWING),
                    label: {
                        Image("opslagicoon")
                    })
            }
        }.background(Color.green)
    }
    private func add(drawing: Drawing, toPath path: inout Path) {
            let points = drawing.points
            if points.count > 1 {
                for i in 0..<points.count-1 {
                    let current = points[i]
                    let next = points[i+1]
                    path.move(to: current)
                    path.addLine(to: next)
                }
            }
        }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(drawingViewModel: DrawingViewModel())
    }
}
