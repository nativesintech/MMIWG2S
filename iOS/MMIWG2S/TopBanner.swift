//
//  TopBanner.swift
//  MMIWG2S
//
//  Created by Marvin Amaro on 6/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit
class TopBannerView:UIView {
    init()
    {
        
        let label = UILabel(frame:CGRect(x:0,y:0,width:200,height:21))
        label.backgroundColor = UIColor(red:50, green:0, blue:12.5/255, alpha:1.0)  
        label.textAlignment = .center
        label.text = "MMIWG2S"
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
