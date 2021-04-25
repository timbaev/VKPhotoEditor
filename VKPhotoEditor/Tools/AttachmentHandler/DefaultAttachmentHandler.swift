//
//  ViewController.swift
//  VKPhotoEditor
//
//  Created by Timur Shafigullin on 25/04/2021.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

final class DefaultAttachmentHandler: NSObject, AttachmentHandler {

    // MARK: - Instance Properties

    private var currentViewController: UIViewController?

    // MARK: -

    var onImageSelected: ((UIImage, String?) -> Void)?
    var onVideoSelected: ((URL) -> Void)?
    var onFilesSelected: (([URL]) -> Void)?

    // MARK: - Instance Methods

    /// This function is used to open camera from the iPhone
    private func openCamera(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }

        let pickerController = UIImagePickerController()

        pickerController.delegate = self
        pickerController.sourceType = .camera

        viewController.present(pickerController, animated: true)
    }

    /// PHOTO PICKER
    private func photoLibrary(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }

        let pickerController = UIImagePickerController()

        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary

        viewController.present(pickerController, animated: true)
    }

    /// VIDEO PICKER
    private func videoLibrary(from viewController: UIViewController) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }

        let pickerController = UIImagePickerController()

        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]

        viewController.present(pickerController, animated: true)
    }

    /// FILE PICKER
    private func documentPicker(from viewController: UIViewController) {
        let picker = UIDocumentPickerViewController(
            documentTypes: [
                "public.mpeg-4:",
                "public.avi",
                "com.microsoft.excel.xls",
                "org.openxmlformats.spreadsheetml.sheet",
                "com.microsoft.word",
                "org.openxmlformats.wordprocessingml.document",
                "com.adobe.pdf",
                "com.apple.quicktime-movie",
            ],
            in: .import
        )

        picker.delegate = self

        viewController.present(picker, animated: true)
    }

    // MARK: -

    /// SETTINGS ALERT
    private func showAlertForSettings(attachmentType: AttachmentType, from viewController: UIViewController) {
        let cameraUnavailableAlertController = UIAlertController(
            title: attachmentType.title,
            message: nil,
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(title: .settingsBtnTitle, style: .destructive, handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })

        let cancelAction = UIAlertAction(title: .cancelBtnTitle, style: .default)

        cameraUnavailableAlertController.addAction(cancelAction)
        cameraUnavailableAlertController.addAction(settingsAction)

        viewController.present(cameraUnavailableAlertController, animated: true)
    }

    // MARK: -

    private func presentPicker(forAttachmentType type: AttachmentType, viewController: UIViewController) {
        switch type {
        case .camera:
            self.openCamera(from: viewController)

        case .photoLibrary:
            self.photoLibrary(from: viewController)

        case .video:
            self.videoLibrary(from: viewController)

        case .file:
            break
        }
    }

    /// This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    /// if the user gives access, then we can import the data safely
    /// if not show them alert to access from settings.
    private func authorizationStatus(attachmentType: AttachmentType, viewController: UIViewController) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized, .limited:
            self.presentPicker(forAttachmentType: attachmentType, viewController: viewController)

        case .denied:
            self.showAlertForSettings(attachmentType: attachmentType, from: viewController)

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.presentPicker(forAttachmentType: attachmentType, viewController: viewController)
                    } else {
                        self.showAlertForSettings(attachmentType: attachmentType, from: viewController)
                    }
                }
            }

        case .restricted:
            self.showAlertForSettings(attachmentType: attachmentType, from: viewController)

        @unknown default:
            fatalError()
        }
    }

    // MARK: -

    private func handleFinishPickingMediaWithInfo(_ info: [UIImagePickerController.InfoKey: Any]) {
        guard let rawMediaType = info[.mediaType] as? String else {
            return
        }

        switch rawMediaType {
        case String(kUTTypeMovie):
            guard let mediaURL = info[.mediaURL] as? URL else {
                return
            }

            self.onVideoSelected?(mediaURL)

        default:
            guard let image = info[.originalImage] as? UIImage, let fixedImage = image.fixedOrientation() else {
                return
            }

            let filename = (info[.phAsset] as? PHAsset).flatMap { asset in
                PHAssetResource.assetResources(for: asset).first?.originalFilename
            }

            self.onImageSelected?(fixedImage, filename)
        }
    }

    // MARK: - AttachmentHandler

    /// This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet(
        from viewController: UIViewController,
        title: String?,
        message: String?,
        availableAttachments: Set<AttachmentType>
    ) {
        self.currentViewController = viewController

        let actionSheet = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )

        if availableAttachments.contains(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: .phoneLibrary, style: .default, handler: { action in
                self.authorizationStatus(attachmentType: .photoLibrary, viewController: viewController)
            }))
        }

        if availableAttachments.contains(.camera) {
            actionSheet.addAction(UIAlertAction(title: .camera, style: .default, handler: { action in
                self.authorizationStatus(attachmentType: .camera, viewController: viewController)
            }))
        }

        if availableAttachments.contains(.video) {
            actionSheet.addAction(UIAlertAction(title: .video, style: .default, handler: { action in
                self.authorizationStatus(attachmentType: .video, viewController: viewController)
            }))
        }

        if availableAttachments.contains(.file) {
            actionSheet.addAction(UIAlertAction(title: .file, style: .default, handler: { action in
                self.documentPicker(from: viewController)
            }))
        }

        actionSheet.addAction(UIAlertAction(title: .cancelBtnTitle, style: .cancel))

        viewController.present(actionSheet, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension DefaultAttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Instance Methods

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.currentViewController?.dismiss(animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        picker.delegate = nil

        self.handleFinishPickingMediaWithInfo(info)
    }
}

// MARK: - UIDocumentPickerDelegate

extension DefaultAttachmentHandler: UIDocumentPickerDelegate {

    // MARK: - Instance Methods

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        self.onFilesSelected?(urls)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.currentViewController?.dismiss(animated: true)
    }
}

// MARK: -

private extension String {

    // MARK: - Type Properties

    static let camera = "Сделать фотографию"
    static let phoneLibrary = "Выбрать из библиотеки"
    static let video = "Видео"
    static let file = "Файл"

    static let settingsBtnTitle = "Настройки"
    static let cancelBtnTitle = "Отмена"
}

// MARK: -

private extension UIImage {

    // MARK: - Instance Methods

    func fixedOrientation() -> UIImage? {
        guard imageOrientation != .up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }

        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }

        guard
            let colorSpace = cgImage.colorSpace,
            let ctx = CGContext(
                data: nil, width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        else { return nil }

        var transform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break

        @unknown default:
            fatalError()
        }

        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError()
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return .init(cgImage: newCGImage, scale: scale, orientation: .up)
    }
}
