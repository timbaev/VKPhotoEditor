//
//  ViewController.swift
//  VKPhotoEditor
//
//  Created by Timur Shafigullin on 25/04/2021.
//

import Foundation

enum AttachmentType: String, CaseIterable {

    // MARK: - Enumeration Cases

    case camera
    case video
    case photoLibrary
    case file

    // MARK: - Instance Properties

    var title: String {
        switch self {
        case .camera:
            return .alertForCameraAccessMessage

        case .video:
            return .alertForVideoLibraryMessage

        case .photoLibrary:
            return .alertForPhotoLibraryMessage

        case .file:
            return .empty
        }
    }
}

// MARK: - Constants

private extension String {

    // MARK: - Type Properties

    static let alertForPhotoLibraryMessage = "Приложение не имеет доступа к вашим фотографиям. Чтобы включить доступ, коснитесь «Настройки» и включите «Доступ к библиотеке фотографий»."
    static let alertForCameraAccessMessage = "Приложение не имеет доступа к вашей камере. Чтобы включить доступ, коснитесь настроек и включите камеру."
    static let alertForVideoLibraryMessage = "У приложения нет доступа к вашему видео. Чтобы включить доступ, коснитесь «Настройки» и включите «Доступ к видеотеке»."

    static let empty = ""
}
