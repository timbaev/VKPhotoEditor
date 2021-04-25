//
//  ViewController.swift
//  VKPhotoEditor
//
//  Created by Timur Shafigullin on 25/04/2021.
//

import UIKit

protocol AttachmentHandler: AnyObject {

    // MARK: - Instance Properties

    var onImageSelected: ((UIImage, String?) -> Void)? { get set }
    var onVideoSelected: ((URL) -> Void)? { get set }
    var onFilesSelected: (([URL]) -> Void)? { get set }

    // MARK: - Instance Methods

    func showAttachmentActionSheet(
        from viewController: UIViewController,
        title: String?,
        message: String?,
        availableAttachments: Set<AttachmentType>
    )
}

// MARK: -

extension AttachmentHandler {

    // MARK: - Instance Methods

    func showAttachmentActionSheet(from viewController: UIViewController) {
        self.showAttachmentActionSheet(
            from: viewController,
            title: .actionFileTypeHeading,
            message: .actionFileTypeDescription,
            availableAttachments: Set<AttachmentType>(AttachmentType.allCases)
        )
    }

    func showAttachmentActionSheet(from viewController: UIViewController, availableAttachments: Set<AttachmentType>) {
        self.showAttachmentActionSheet(
            from: viewController,
            title: .actionFileTypeHeading,
            message: .actionFileTypeDescription,
            availableAttachments: availableAttachments
        )
    }
}

// MARK: -

private extension String {

    // MARK: - Type Properties

    static let actionFileTypeHeading = "Добавить файл"
    static let actionFileTypeDescription = "Выберите тип файла для добавления..."
}
