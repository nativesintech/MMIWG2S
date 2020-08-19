//
//  Extensions.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 8/16/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import UIKit
import VideoToolbox

extension String {
    // TODO: reference localized strings
}

extension UIFont {
    static var roboto24: UIFont { return UIFont(name: "Roboto-Regular", size: 24)! }
}

extension UIColor {
    static var lightGray: UIColor { return UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1.0) }
    static var lightGrayHalfAlpha: UIColor { return UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 0.5) }
    static var offBlack: UIColor { return UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1.0) }
    static var offRed: UIColor { return UIColor(red: 177 / 255, green: 14 / 255, blue: 15 / 255, alpha: 1.0) }
}

extension UIImage {
    convenience init?(pixelBuffer: CVPixelBuffer, orientation: UIImage.Orientation) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        guard cgImage != nil else {
            return nil
        }
        self.init(cgImage: cgImage!, scale: 1.0, orientation: orientation)
    }
}

extension UIImage.Orientation {
    static func from(deviceOrientation: UIDeviceOrientation) -> UIImage.Orientation {
        switch deviceOrientation {
        case .landscapeLeft:
            return .upMirrored
        case .faceDown:
            return .rightMirrored
        case .landscapeRight:
            return .downMirrored
        default:
            return .leftMirrored
        }
    }
}
