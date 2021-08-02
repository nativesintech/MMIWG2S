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
            return FacesViewController()
        }
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
