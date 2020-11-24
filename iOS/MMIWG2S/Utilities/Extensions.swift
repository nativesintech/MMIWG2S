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
    static let ok = NSLocalizedString("error.ok", comment: "Ok")
    static let errorARSessionTitle = NSLocalizedString("error.arsessionfailure", comment: "Title for error message when AR session fails")
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

extension UIViewController {
    func displayError(_ title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: .ok, style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            completion?()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    class var top: UIViewController? { get { return getTopViewController() } }
    
    private class func getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return getTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        return controller
    }
}

extension UIView {
    
    func animateCornerRadius(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        CATransaction.begin()
        let animationKeyPath = "cornerRadius"
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.cornerRadius = to
        }
        layer.add(animation, forKey: animationKeyPath)
        CATransaction.commit()
    }
    
}
