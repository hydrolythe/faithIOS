//
//  PhotoViewModel.swift
//  FAITH
//
//  Created by Guylian Bollon on 08/05/2021.
//

import Foundation
import SwiftUI

class PhotoViewModel:ObservableObject{
    func saveImage(imageName: String, image: UIImage) -> Recording {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return Recording(fileURL: nil, createdAt: nil) }
                let fileName = imageName
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return Recording(fileURL: nil, createdAt: nil) }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        return Recording(fileURL: fileURL, createdAt: Date())
    }
}
