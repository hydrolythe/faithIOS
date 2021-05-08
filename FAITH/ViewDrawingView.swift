//
//  ViewDrawingView.swift
//  FAITH
//
//  Created by Guylian Bollon on 07/05/2021.
//

import SwiftUI

struct ViewDrawingView: View {
    @State var recording: Recording
    
    var body: some View {
        VStack{
            Image(uiImage: (UIImage(data: try! Data(contentsOf: recording.fileURL!))) ?? UIImage())
        }
    }
}

struct ViewDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewDrawingView(recording: Recording(fileURL: nil, createdAt: nil))
    }
}
