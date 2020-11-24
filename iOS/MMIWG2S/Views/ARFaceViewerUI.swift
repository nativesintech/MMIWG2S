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
    private let shareButtonBottomPadding: CGFloat = 50
    private let shareButtonDiameter: CGFloat = 105
    private let toggleViewWidth: CGFloat = 97
    private let toggleViewBottomPadding: CGFloat = 75
    
    var redSelected = true
    private var blackButton: SceneButton?
    private var redButton: SceneButton?
    
    var delegate: ARFaceViewerUIDelegate?
    
    func setupShareButton() {
        let shareButton = SceneButton(diameter: shareButtonDiameter, color: .lightGray)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -shareButtonBottomPadding).isActive = true
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
    
    @objc private func shareButtonTapped() {
        guard let imageToShare = delegate?.generateShareImage() else { return }
        
        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityController.completionWithItemsHandler = { [weak self] (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            self?.delegate?.resumeSessionOnceCaptured()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = self
            activityController.popoverPresentationController?.sourceRect = CGRect(x: self.frame.size.width / 2 , y: self.frame.size.height / 4, width: 0, height: 0)
        }
        
        UIViewController.top?.present(activityController, animated: true)
    }
    
    @objc private func blackButtonTapped() {
        guard redSelected else { return }
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
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
           guard let self = self else { return }
            self.blackButton?.adjustDiameter(to: SceneButton.smallerColorToggleWidth)
            self.redButton?.adjustDiameter(to: SceneButton.largerColorToggleWidth)
        })
        redSelected = true
        delegate?.textureChanged(toRed: true)
    }
}
