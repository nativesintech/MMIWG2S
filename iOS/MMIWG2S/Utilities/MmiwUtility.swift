//
//  MmiwUtility.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 7/12/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit
import ARKit

class MmiwUtility {
    static var faceViewController: UIViewController {
        if ARFaceTrackingConfiguration.isSupported {
            return FacesARViewController()
        } else {
            return InfoSheetViewController(image: UIImage(named: "unsupported-device"), title: .unsupporteddevicetitle, message: .unsupporteddevicebody)
        }
    }

    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }

    static func thankYouViewController(showBackButton: Bool) -> ThankYouSheetViewController { ThankYouSheetViewController(
        showBackButton: showBackButton,
        header: .mmiw,
        videoDescription: .thankyouvideodescription,
        videoUrl: "https://www.youtube-nocookie.com/embed/NscqDqT0L18",
        subheader: .thankyousubheader,
        thankYouBody: .thankyoubody)
    }

    // MARK: UserDefault Helper methods
    enum UserDefaultKey: String {
        case accepted
    }

    static func saveUserDefaultBool(defaultType: UserDefaultKey, with value: Bool) {
        UserDefaults.standard.set(value, forKey: defaultType.rawValue)
    }

    static func getUserDefaultBool(defaultType: UserDefaultKey) -> Bool {
        UserDefaults.standard.bool(forKey: defaultType.rawValue)
    }
}
