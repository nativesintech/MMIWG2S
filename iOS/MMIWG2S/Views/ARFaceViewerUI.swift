//
//  ARFaceViewerUI.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 10/25/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import UIKit

protocol ARFaceViewerUIDelegate {
    func textureChanged(toRed: Bool)
    func generateShareImage() -> UIImage?
    func resumeSessionOnceCaptured()
}

class ARFaceViewerUI: UIView {
    private var captureButton: SceneButton?
    private let captureButtonBottomPadding: CGFloat = 50
    private let captureButtonDiameter: CGFloat = 105
    private let toggleViewWidth: CGFloat = 97
    private let toggleViewBottomPadding: CGFloat = 75

    private var shareButton: IconButton?
    private var shareButtonAction: (() -> Void)?
    private var backButton: IconButton?
    private let iconButtonTopMargin: CGFloat = 32
    private let iconButtonSideMargin: CGFloat = 16

    private let headerViewTopMargin: CGFloat = 20

    private var imageToShare: UIImage?
    
    var redSelected = true
    private var blackButton: SceneButton?
    private var redButton: SceneButton?
    private var captionPickerView: CaptionPickerView?
    private var headerView: UIView?
    
    var delegate: ARFaceViewerUIDelegate?
    var shareSheetViewController: ShareSheetViewController?
    
    func setupCaptureButton() {
        captureButton = SceneButton(diameter: captureButtonDiameter, color: .lightGray)
        if let captureButton = captureButton {
            captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)

            addSubview(captureButton)
            captureButton.translatesAutoresizingMaskIntoConstraints = false
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            captureButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -captureButtonBottomPadding).isActive = true
        }
    }
    
    func setupColorToggle() {
        let toggleView = UIView()
        addSubview(toggleView)
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.widthAnchor.constraint(equalToConstant: toggleViewWidth).isActive = true
        toggleView.heightAnchor.constraint(equalToConstant: SceneButton.largerColorToggleWidth).isActive = true
        toggleView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 2 / 7).isActive = true
        toggleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -toggleViewBottomPadding).isActive = true
        
        
        let blackButton = SceneButton(diameter: SceneButton.smallerColorToggleWidth, color: .offBlack)
        blackButton.addTarget(self, action: #selector(blackButtonTapped), for: .touchUpInside)
        
        toggleView.addSubview(blackButton)
        blackButton.translatesAutoresizingMaskIntoConstraints = false
        blackButton.leadingAnchor.constraint(equalTo: toggleView.leadingAnchor).isActive = true
        blackButton.centerYAnchor.constraint(equalTo: toggleView.centerYAnchor).isActive = true
        self.blackButton = blackButton
        
        
        let redButton = SceneButton(diameter: SceneButton.largerColorToggleWidth, color: .offRed)
        redButton.addTarget(self, action: #selector(redButtonTapped), for: .touchUpInside)
        
        toggleView.addSubview(redButton)
        redButton.translatesAutoresizingMaskIntoConstraints = false
        redButton.trailingAnchor.constraint(equalTo: toggleView.trailingAnchor).isActive = true
        redButton.centerYAnchor.constraint(equalTo: toggleView.centerYAnchor).isActive = true
        self.redButton = redButton
    }

    func setupShareBackButtons(shareAction: @escaping (() -> Void)) {
        shareButtonAction = shareAction
        shareButton = setupButton(named: "share-icon", title: String.share, isTrailing: true)
        backButton = setupButton(named: "back-icon", title: String.back, isTrailing: false)
    }

    func setupButton(named: String, title: String, isTrailing: Bool) -> IconButton? {
        if let buttonImage = UIImage(named: named) {
            let iconButton = IconButton(image: buttonImage, text: title)
            addSubview(iconButton)
            iconButton.translatesAutoresizingMaskIntoConstraints = false
            iconButton.isHidden = true

            iconButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: iconButtonTopMargin).isActive = true
            switch isTrailing {
            case true:
                iconButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -iconButtonSideMargin).isActive = true
            case false:
                iconButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: iconButtonSideMargin).isActive = true
            }

            let buttonGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: isTrailing ? #selector(self.shareButtonTapped) : #selector(self.backButtonTapped)
            )
            iconButton.isUserInteractionEnabled = true
            iconButton.addGestureRecognizer(buttonGestureRecognizer)

            return iconButton
        }
        return nil
    }
    
    func setupCaptionPickerView() {
        let captionPickerView = CaptionPickerView()
        
        self.insertSubview(captionPickerView, at: 0)
        captionPickerView.translatesAutoresizingMaskIntoConstraints = false
        captionPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        captionPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        captionPickerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        captionPickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        captionPickerView.isHidden = true
        self.captionPickerView = captionPickerView
    }
    
    private func uploadImage(_ compressedImage: UIImage, name: String, email: String) {
        guard let nameData = name.data(using: .utf8),
              let emailData = email.data(using: .utf8),
              let verifiedData = "1".data(using: .utf8)
        else { return }
        
        guard let imageData = compressedImage.pngData() else {
            log.error("Unable to get image data. Posting user metadata without image")
            Network.post(
                url: "https://mmiw.mehequanna.com/submissions",
                data: [
                    "name" : ("text", nameData),
                    "email" : ("text", emailData),
                    "verified" : ("text", verifiedData)
                ],
                contentType: .multipartForm,
                completionHandler: { error, response in
                    if let response = response {
                        log.info(String(data: response, encoding: .utf8) ?? "[unable to decode]")
                    }
                }
            )
            return
        }
        Network.post(
            url: "https://mmiw.mehequanna.com/submissions",
            data: [
                "name" : ("text", nameData),
                "email" : ("text", emailData),
                "verified" : ("text", verifiedData),
                "image" : ("image/png", imageData)
            ],
            contentType: .multipartForm,
            completionHandler: { error, response in
                if let response = response {
                    log.info(String(data: response, encoding: .utf8) ?? "[unable to decode]")
                }
            }
        )
    }

    func setupBannerAndStatViews() {
        let gradientView = UIImageView(image: UIImage(named: "ar-background"))
        let headerView = UILabel()
        headerView.text = .mmiw
        headerView.font = .roboto48
        headerView.textColor = .white

        addSubview(gradientView)
        addSubview(headerView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: headerViewTopMargin)
        ])
        self.headerView = headerView
    }
    
    @objc private func captureButtonTapped() {
        generateLightFeedback()
        captureButton?.changeInnerButtonColorOnTap(color: .black)
        imageToShare = delegate?.generateShareImage()
        // Added a delay so the captureButton.changeInnerButtonColorOnTap animation can complete.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) { [weak self] in
            self?.changeViewVisibility(isCapturing: false)
        }
    }
    
    private func shareWithUs(name: String, email: String) {
        guard let imageToShare = imageToShare else { return }
        
        // Use this to upload to the database. This will likely move :)
        let scaledDownImage = imageToShare.compress(to: 1000)

        self.uploadImage(scaledDownImage, name: name, email: email)
        self.shareImage()
    }
    
    @objc private func blackButtonTapped() {
        guard redSelected else { return }
        generateLightFeedback()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.blackButton?.adjustDiameter(to: SceneButton.largerColorToggleWidth)
            self.redButton?.adjustDiameter(to: SceneButton.smallerColorToggleWidth)
        })
        redSelected = false
        delegate?.textureChanged(toRed: false)
    }
    
    @objc private func redButtonTapped() {
        guard !redSelected else { return }
        generateLightFeedback()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.blackButton?.adjustDiameter(to: SceneButton.smallerColorToggleWidth)
            self.redButton?.adjustDiameter(to: SceneButton.largerColorToggleWidth)
        })
        redSelected = true
        delegate?.textureChanged(toRed: true)
    }

    @objc private func shareButtonTapped() {
        generateLightFeedback()
        backButton?.isHidden = true
        shareButton?.isHidden = true
        
        guard let imageToShare = imageToShare,
              let gradientView = UIImage(named: "gradient1"),
              let captionPicker = captionPickerView?.asImageWithoutPaginationIndicator(),
              let headerView = headerView
        else {
            log.error("Missing share image or caption picker view")
            return
        }
        
        let pixelToUnitRatio = imageToShare.size.width / frame.width
        
        UIGraphicsBeginImageContextWithOptions(imageToShare.size, true, 0.0)
        imageToShare.draw(in: CGRect(origin: .zero, size: imageToShare.size))
        gradientView.draw(in: CGRect(origin: .zero, size: imageToShare.size))
        captionPicker.draw(in: CGRect(origin: .zero, size: imageToShare.size))
        headerView.asImage().draw(in: CGRect(origin: headerView.frame.origin * pixelToUnitRatio, size: headerView.frame.size * pixelToUnitRatio))
        let imageWithContent = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.imageToShare = imageWithContent

        shareSheetViewController = ShareSheetViewController(image: imageWithContent, title: .sharepagetitle, message: .sharepagemessage)
        shareSheetViewController?.setupButtonActions(back: { self.backButtonsAction() }, share: { name, email in
            self.shareWithUs(name: name, email: email)
        }, skip: { self.shareImage() })

        shareButtonAction?()
    }

    @objc private func backButtonTapped() {
        backButtonsAction()
    }

    private func backButtonsAction() {
        generateLightFeedback()
        delegate?.resumeSessionOnceCaptured()
        changeViewVisibility(isCapturing: true)
    }

    private func generateLightFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.impactOccurred()
    }

    private func shareImage() {
        guard let imageToShare = imageToShare else { return }

        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityController.completionWithItemsHandler = { [weak self] (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self?.delegate?.resumeSessionOnceCaptured()
            self?.changeViewVisibility(isCapturing: true)
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = self
            activityController.popoverPresentationController?.sourceRect = CGRect(x: self.frame.size.width / 2 , y: self.frame.size.height / 4, width: 0, height: 0)
        }

        UIViewController.top?.present(activityController, animated: true)
    }

    func changeViewVisibility(isCapturing: Bool) {
        blackButton?.isHidden = !isCapturing
        redButton?.isHidden = !isCapturing
        captureButton?.isHidden = !isCapturing
        captureButton?.isEnabled = isCapturing

        backButton?.isHidden = isCapturing
        shareButton?.isHidden = isCapturing
        
        captionPickerView?.isHidden = isCapturing
    }
}
