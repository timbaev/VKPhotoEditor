//
//  ToolBarButtonImageBuilder.swift
//  iOSPhotoEditor
//
//  Created by Timur Shafigullin on 25/04/2021.
//

import Foundation

struct ToolBarButtonImageBuilder {

    static func clampImage() -> UIImage? {
        var clampImage: UIImage? = nil

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 16), false, 0.0)

        //// Color Declarations
        let outerBox = UIColor(red: 1, green: 1, blue: 1, alpha: 0.553)
        let innerBox = UIColor(red: 1, green: 1, blue: 1, alpha: 0.773)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 3, width: 13, height: 13))
        UIColor.white.setFill()
        rectanglePath.fill()


        //// Outer
        //// Top Drawing
        let topPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 22, height: 2))
        outerBox.setFill()
        topPath.fill()

        //// Side Drawing
        let sidePath = UIBezierPath(rect: CGRect(x: 19, y: 2, width: 3, height: 14))
        outerBox.setFill()
        sidePath.fill()

        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 14, y: 3, width: 4, height: 13))
        innerBox.setFill()
        rectangle2Path.fill()

        clampImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return clampImage
    }
}
