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
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    static let ok = NSLocalizedString("error.ok", comment: "Ok")
    static let errorARSessionTitle = NSLocalizedString("error.arsessionfailure", comment: "Title for error message when AR session fails")
    static let missing = NSLocalizedString("intro.missing", comment: "Missing")
    static let murdered = NSLocalizedString("intro.murdered", comment: "Murdered")
    static let indigenous = NSLocalizedString("intro.indigenous", comment: "Indigenous")
    static let women = NSLocalizedString("intro.women", comment: "Women")
    
    // text for Acceptance page
    static func acceptance(number: Int) -> String {
        return NSLocalizedString("acceptance.\(number).text", comment: "Acceptance")
    }
    static let agree = NSLocalizedString("acceptance.agree", comment: "I Agree")

    static var next: String { return NSLocalizedString("indicator.next", comment: "Next button title") }
    static var slideviewheader: String { return NSLocalizedString("slideview.header", comment: "Text") }
    static func statistic(number: Int) -> String {
        return NSLocalizedString("statistic.\(number).text", comment: "text for a statistic used on the title slides or in the caption picker") }
    
    func width(for font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: fontAttributes).width
    }

    static let mmiw = NSLocalizedString("editview.header", comment: "#MMIW")
    static let share = NSLocalizedString("iconbutton.share", comment: "Share")
    static let back = NSLocalizedString("iconbutton.back", comment: "Back")

    static let sharepageshare = NSLocalizedString("sharepage.share", comment: "Share")
    static let sharepageskip = NSLocalizedString("sharepage.skip", comment: "Skip")
    static let sharepagename = NSLocalizedString("sharepage.name", comment: "Name")
    static let sharepageemail = NSLocalizedString("sharepage.emailaddress", comment: "Email Address")
    static let sharepagetitle = NSLocalizedString("sharepage.header", comment: "Share with us?")
    static let sharepagemessage = NSLocalizedString("sharepage.message", comment: "What we will do with the info")
    static let sharepageerrorlabel = NSLocalizedString("sharepage.errorlabel", comment: "Field required error.")

    static let unsupporteddevicetitle = NSLocalizedString("unsupporteddevice.title", comment: "Unsupported Device Title")
    static let unsupporteddevicebody = NSLocalizedString("unsupporteddevice.body", comment: "Unsupported Device Body")
    static let camerapermissionstitle = NSLocalizedString("camerapermissions.title", comment: "Camera Permissions Needed Title")
    static let camerapermissionsbody = NSLocalizedString("camerapermissions.body", comment: "Camera Permissions Needed Body")
    static let camerapermissionsbuttonname = NSLocalizedString("camerapermissions.button.name", comment: "Camera Permissions Button Name")

    static let thankyouvideodescription = NSLocalizedString("thankyou.videodesciption", comment: "Video description")
    static let thankyousubheader = NSLocalizedString("thankyou.subheader", comment: "Thank you subheader")
    static let thankyoubody = NSLocalizedString("thankyou.body", comment: "Thank you body")
}

extension UIFont {
    static var roboto14: UIFont { return UIFont(name: "Roboto-Regular", size: 14) ?? .systemFont(ofSize: 14) }
    static var roboto16: UIFont { return UIFont(name: "Roboto-Regular", size: 16) ?? .systemFont(ofSize: 16) }
    static var roboto17: UIFont { return UIFont(name: "Roboto-Regular", size: 17) ?? .systemFont(ofSize: 17) }
    static var roboto18: UIFont { return UIFont(name: "Roboto-Regular", size: 18) ?? .systemFont(ofSize: 18) }
    static var roboto24: UIFont { return UIFont(name: "Roboto-Regular", size: 24) ?? .systemFont(ofSize: 24) }
    static var roboto36: UIFont { return UIFont(name: "Roboto-Regular", size: 36) ?? .systemFont(ofSize: 36) }
    static var roboto48: UIFont { return UIFont(name: "Roboto-Regular", size: 48) ?? .systemFont(ofSize: 48) }
}

extension UIColor {
    static var lightGray: UIColor { return UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1.0) }
    static var lightGrayHalfAlpha: UIColor { return UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 0.5) }
    static var lightGrayThirdAlpha: UIColor { return UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 0.3) }
    static var offBlack: UIColor { return UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1.0) }
    static var offRed: UIColor { return UIColor(red: 177 / 255, green: 14 / 255, blue: 15 / 255, alpha: 1.0) }
}

extension Int {
    static func toDeviceFormattedCGFloat(ipad: Int, iphone: Int) -> CGFloat {
        return CGFloat(MmiwUtility.isPad ? ipad : iphone)
    }
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
    
    func compress(maxKb: Double) -> Data? {
        let quality: CGFloat = maxKb / self.sizeAsKb()
        return self.jpegData(compressionQuality: quality)
    }
    
    func sizeAsKb() -> Double {
        Double(self.pngData()?.count ?? 0 / 1024)
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
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
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

public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/// Borrowed from https://stackoverflow.com/a/64642247/12470155
extension Data {
    mutating func addMultiPart(boundary: String, key: String, value: String, contentType: String? = nil, data: Data? = nil) {
        log.info("adding boundary: \(boundary), key: \(key), value: \(value), contentType: \(String(describing: contentType)) data length: \(String(describing: data?.count)) ")
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
