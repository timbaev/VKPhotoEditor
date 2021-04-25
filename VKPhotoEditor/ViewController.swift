//
//  ViewController.swift
//  VKPhotoEditor
//
//  Created by Timur Shafigullin on 25/04/2021.
//

import UIKit
import iOSPhotoEditor

class ViewController: UIViewController {

    // MARK: - Instance Methods

    private func showPhotoEditor(image: UIImage) {
        let photoEditor = PhotoEditorViewController(
            nibName: "PhotoEditorViewController",
            bundle: Bundle(for: PhotoEditorViewController.self)
        )

        photoEditor.image = image
        photoEditor.modalPresentationStyle = .fullScreen

        present(photoEditor, animated: true)
    }

    @IBAction private func onPickPhotoButtonTap(_ sender: UIButton) {
        Dependencies.attachmentHandler.onImageSelected = { [weak self] image, filename in
            self?.showPhotoEditor(image: image)
        }

        Dependencies
            .attachmentHandler
            .showAttachmentActionSheet(
                from: self,
                title: nil,
                message: nil,
                availableAttachments: [.camera, .photoLibrary]
            )
    }
}
