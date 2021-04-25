//
//  PhotoEditor+Filter.swift
//  iOSPhotoEditor
//
//  Created by Timur Shafigullin on 25/04/2021.
//

import Foundation

extension PhotoEditorViewController {

    // MARK: - Instance Methods

    private func updateImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }

        DispatchQueue.main.async {
            self.setImageView(image: image)
            self.activityIndicatorView.stopAnimating()
        }
    }

    // MARK: -

    func apply(filter: Filter) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()

        DispatchQueue.global().async {
            if let applier = filter.applier,
               let ciImage = self.originalImage?.asCIImage,
               let modifiedImage = applier(ciImage) {
                self.updateImage(modifiedImage.uiImage)
            } else {
                self.updateImage(self.originalImage)
            }
        }
    }
}

// MARK: -

private extension UIImage {

    // MARK: - Instance Properties

    var asCIImage: CIImage? {
        ciImage ?? cgImage.map { CIImage(cgImage: $0) }
    }
}

// MARK: -

private extension CIImage {

    // MARK: - Instance Properties

    var uiImage: UIImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(self, from: self.extent)!
        let image = UIImage(cgImage: cgImage)

        return image
    }
}
