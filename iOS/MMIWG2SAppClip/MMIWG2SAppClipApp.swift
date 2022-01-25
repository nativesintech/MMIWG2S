//
//  MMIWG2SAppClipApp.swift
//  MMIWG2SAppClip
//
//  Created by Stephen Emery on 1/20/22.
//  Copyright © 2022 Google LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class MMIWG2SAppClipApp: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: IntroAnimationViewController())
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
