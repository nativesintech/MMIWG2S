//
//  Extensions.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 8/11/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static var next: String { return NSLocalizedString("indicator.next", comment: "Next button title") }
}

extension UIFont {
    static var roboto24: UIFont { return UIFont(name: "Roboto-Regular", size: 24)! }
}

extension UIColor {
    static var darkRed: UIColor { return UIColor(red: 177 / 255, green: 14 / 255, blue: 15 / 255, alpha: 1.0) }
}
