//
//  ImageLoader.swift
//  FAITH
//
//  Created by Guylian Bollon on 08/05/2021.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
        var data = Data() {
            didSet {
                didChange.send(data)
            }
        }

    init(url:URL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.data = data
                }
            }
            task.resume()
        }
}
