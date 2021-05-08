//
//  CaptureImageView.swift
//  FAITH
//
//  Created by Guylian Bollon on 26/03/2021.
//

import Foundation
import SwiftUI

struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: UIImage
       
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
}
extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
