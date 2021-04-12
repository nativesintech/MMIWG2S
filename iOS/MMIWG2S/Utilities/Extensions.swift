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
    static let missing = NSLocalizedString("intro.missing", comment: "Missing")
    static let murdered = NSLocalizedString("intro.murdered", comment: "Murdered")
    static let indigenous = NSLocalizedString("intro.indigenous", comment: "Indigenous")
    static let women = NSLocalizedString("intro.women", comment: "Women")
    
    func width(for font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: fontAttributes).width
    }
}

extension UIFont {
    static var roboto24: UIFont { return UIFont(name: "Roboto-Regular", size: 24) ?? .systemFont(ofSize: 24) }
    static var roboto48: UIFont { return UIFont(name: "Roboto-Regular", size: 48) ?? .systemFont(ofSize: 48) }
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
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return imageColored
    }
}

extension UIImage.Orientation {
    static func from(deviceOrientation: UIDeviceOrientation) -> UIImage.Orientation {
        switch deviceOrientation {
        case .landscapeLeft:
            return .down
        case .faceDown:
            return .left
        case .landscapeRight:
            return .up
        default:
            return .right
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

extension UILabel {
    var width: CGFloat {
        guard let text = text, let font = font else { return 0 }
        return text.width(for: font)
    }
}

public func * (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width * scalar, height: size.height * scalar)
}

/// Borrowed from https://stackoverflow.com/a/64642247/12470155
extension Data {
    mutating func addMultiPart(boundary: String, key: String, value: String, contentType: String? = nil, data: Data? = nil) {
        log.info("adding boundary: \(boundary), key: \(key), value: \(value), contentType: \(contentType) data length: \(data?.count) ")
        self.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        if let contentType = contentType, let data = data { // if file
            self.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(value)\"\r\n".data(using: .utf8)!)
            self.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
            self.append(data)
        }
        else { // else form parameters
            self.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            self.append("\(value)".data(using: .utf8)!)
        }
    }
    mutating func addMultiPartEnd(boundary: String) {
        self.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    }
}
