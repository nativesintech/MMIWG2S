//
//  ShareSheetView.swift
//  MMIWG2S
//
//  Created by Stephen Emery on 5/7/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

class ShareSheetViewController: UIViewController, UITextFieldDelegate {
    private let sheetViewWidth: CGFloat =
        UIDevice.current.userInterfaceIdiom == .pad ? 440 : 350

    private var shareSheetView = ShareSheetView()
    private var keyboardIsUp = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func keyboardWiilChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }

    convenience init(image: UIImage? = nil, title: String, message: String) {
        self.init()

        view.backgroundColor = .offBlack
        modalPresentationStyle = .pageSheet
        modalTransitionStyle = .coverVertical

        if let image = image {
            shareSheetView = ShareSheetView(
                viewConfig: ShareSheetView.ShareSheetViewConfig(
                    image: image,
                    title: title,
                    message: message
                )
            )
        }

// TODO this makes a pretty heavy jump in the UI. Need to figure out why.
//        testsheetView.setTextFieldDelegates(delegate: self)

        view.addSubview(shareSheetView)
        shareSheetView.translatesAutoresizingMaskIntoConstraints = false
        shareSheetView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shareSheetView.widthAnchor.constraint(equalToConstant: sheetViewWidth).isActive = true
        shareSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        shareSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }

    func setupButtonActions(back: @escaping (() -> Void), share: @escaping ((_ name: String, _ email: String) -> Void), skip: @escaping (() -> Void)) {
        // TODO add completion functions
        shareSheetView.setbuttonActions(
            backAction: { self.dismiss(animated: true, completion: back) },
            shareAction: { name, email in
                self.dismiss(animated: true, completion: { share(name, email) })
            },
            skipAction: { self.dismiss(animated: true, completion: skip) }
        )
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shareSheetView.setTextFieldFirstResponder()
        return false
    }
}
