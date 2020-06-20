//
//  BottomBanner.swift
//  MMIWG2S
//
//  Created by Marvin Amaro on 6/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit
class BottomBannerView:UIView {
    let label = UILabel(frame:CGRect(x:0,y:0,width:200,height:21))

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        label.backgroundColor = UIColor(red:129/255, green:23/255, blue:14/255, alpha:0.9)
        label.textAlignment = .center
        label.text = "MMIWG2S"
        self.addSubview(label)
        setupUI()
        
    }
    
    func setupUI()
    {
        // Setup UI
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup Constraints
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label]|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["label":self.label]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["label":self.label]))

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
