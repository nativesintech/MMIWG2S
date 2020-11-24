//
//  SceneButton.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 8/18/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit

class SceneButton: UIButton {
    private let outerStroke: CGFloat = 7
    
    private let innerButton = UIButton()
    private let color: UIColor
    private var diameter: CGFloat
    
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    static let largerColorToggleWidth: CGFloat = 54
    static let smallerColorToggleWidth: CGFloat = 36

    init(diameter: CGFloat, color: UIColor) {
        self.color = color
        self.diameter = diameter
        super.init(frame: .zero)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        super.addTarget(target, action: action, for: controlEvents)
        innerButton.addTarget(target, action: action, for: controlEvents)
    }
    
    // Must be called on the main thread
    func adjustDiameter(to diameter: CGFloat) {
        layer.cornerRadius = diameter / 2
        innerButton.layer.cornerRadius = (diameter / 2) - outerStroke
        widthConstraint?.constant = diameter
        heightConstraint?.constant = diameter
        self.diameter = diameter
    }
    
    private func addViews() {
        widthConstraint = widthAnchor.constraint(equalToConstant: diameter)
        widthConstraint?.isActive = true
        heightConstraint = heightAnchor.constraint(equalToConstant: diameter)
        heightConstraint?.isActive = true
        
        layer.cornerRadius = diameter / 2
        backgroundColor = .lightGrayHalfAlpha
        
        innerButton.layer.cornerRadius = (diameter / 2) - outerStroke
        innerButton.backgroundColor = color
        
        addSubview(innerButton)
        innerButton.translatesAutoresizingMaskIntoConstraints = false
        innerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: outerStroke).isActive = true
        innerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -outerStroke).isActive = true
        innerButton.topAnchor.constraint(equalTo: topAnchor, constant: outerStroke).isActive = true
        innerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -outerStroke).isActive = true
    }
}
