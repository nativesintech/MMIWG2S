//
//  Extensions.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 6/24/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import UIKit
import VideoToolbox

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
