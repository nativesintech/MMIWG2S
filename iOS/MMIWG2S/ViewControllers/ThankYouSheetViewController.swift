//
//  ThankYouSheetViewController.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 10/14/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

class ThankYouSheetViewController: UIViewController {
    private let sheetViewWidth: CGFloat = Int.toDeviceFormattedCGFloat(ipad: 600, iphone: 350)
    var thankYouSheetView: ThankYouSheetView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    convenience init(showBackButton: Bool, header: String, videoDescription: String, videoUrl: String, subheader: String, thankYouBody: String) {
        self.init()

        view.backgroundColor = .offBlack
        modalPresentationStyle = .pageSheet
        modalTransitionStyle = .coverVertical

        thankYouSheetView = ThankYouSheetView(
            viewConfig: ThankYouSheetView.ThankYouSheetViewConfig(
                showBackButton: showBackButton,
                header: header,
                videoDescription: videoDescription,
                videoUrl: videoUrl,
                subheader: subheader,
                thankYouBody: thankYouBody)
        )

        guard let thankYouSheetView = thankYouSheetView else {
            print("Warning: thankYouSheetView not initialized.")
            return
        }

        view.addSubview(thankYouSheetView)
        thankYouSheetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thankYouSheetView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            thankYouSheetView.widthAnchor.constraint(equalToConstant: sheetViewWidth),
//            thankYouSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            thankYouSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            thankYouSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: Int.toDeviceFormattedCGFloat(ipad: 86, iphone: 64)),
            thankYouSheetView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }

    func setupButtonActions(back: @escaping (() -> Void)) {
        thankYouSheetView?.setbuttonActions(
            backAction: { self.dismiss(animated: true, completion: back) })
    }
}
