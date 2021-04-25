//
//  PhotoEditor+Crop.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - CropView
extension PhotoEditorViewController: CropViewControllerDelegate {
    
    public func cropViewController(
        _ controller: CropViewController,
        didFinishCroppingImage image: UIImage,
        transform: CGAffineTransform,
        cropRect: CGRect
    ) {
        croppedImage = image
        controller.dismiss(animated: true, completion: nil)

        if let filter = currentFilter {
            apply(filter: filter)
        } else {
            setImageView(image: image)
        }
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
