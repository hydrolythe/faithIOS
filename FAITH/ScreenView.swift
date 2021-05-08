//
//  ScreenView.swift
//  FAITH
//
//  Created by Guylian Bollon on 08/05/2021.
//

import SwiftUI

struct ScreenView: View {
    private enum LoadState {
            case loading, success, failure
        }

        private class Loader: ObservableObject {
            var data = Data()
            var state = LoadState.loading

            init(recording:Recording) {
                guard let parsedURL = recording.fileURL else {
                    fatalError("Invalid URL: \(recording.fileURL)")
                }
                print(recording.fileURL)
                URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                    if let data = data, data.count > 0 {
                        self.data = data
                        self.state = .success
                    } else {
                        self.state = .failure
                    }

                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                }.resume()
            }
        }

        @StateObject private var loader: Loader
        var loading: Image
        var failure: Image

        var body: some View {
            selectImage()
                .resizable()
        }

        init(recording: Recording, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
            _loader = StateObject(wrappedValue: Loader(recording: recording))
            self.loading = loading
            self.failure = failure
        }

        private func selectImage() -> Image {
            switch loader.state {
            case .loading:
                return loading
            case .failure:
                return failure
            default:
                if let image = UIImage(data: loader.data) {
                    return Image(uiImage: image)
                } else {
                    return failure
                }
            }
        }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView(recording: Recording(fileURL: nil, createdAt: nil))
    }
}
