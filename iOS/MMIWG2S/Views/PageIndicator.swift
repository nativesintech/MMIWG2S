//
//  PageIndicator.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 8/11/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit

class PageIndicator: UIButton {
    private let totalPages: Int
    private let indicatorWidth: CGFloat = 2
    private let indicatorGap: CGFloat = 3
    private let textWidth: CGFloat = 70
    
    private var pages: [UIView] = []
    
    let height: CGFloat = 17
    
    var currentPage: Int {
        didSet {
            setPage()
        }
    }
    var width: CGFloat { return CGFloat(totalPages) * (indicatorWidth + indicatorGap) + textWidth }

    init(page: Int, of totalPages: Int) {
        self.currentPage = page
        self.totalPages = totalPages
        super.init(frame: .zero)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        for i in 0..<totalPages {
            let page = UIView()
            page.backgroundColor = i == currentPage ? .darkRed : .white
            
            addSubview(page)
            page.translatesAutoresizingMaskIntoConstraints = false
            page.leadingAnchor.constraint(equalTo: pages.last?.trailingAnchor ?? leadingAnchor, constant: i == 0 ? 0 : indicatorGap).isActive = true
            page.widthAnchor.constraint(equalToConstant: indicatorWidth).isActive = true
            page.topAnchor.constraint(equalTo: topAnchor).isActive = true
            page.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            pages.append(page)
        }
        
        let nextLabel = UILabel()
        nextLabel.text = .next
        nextLabel.font = .roboto24
        nextLabel.textColor = .white
        
        addSubview(nextLabel)
        nextLabel.translatesAutoresizingMaskIntoConstraints = false
        nextLabel.leadingAnchor.constraint(equalTo: pages.last?.trailingAnchor ?? leadingAnchor, constant: indicatorGap).isActive = true
        nextLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nextLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nextLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setPage() {
        pages.enumerated().forEach { index, page in
            page.backgroundColor = index == currentPage ? .darkRed : .white
        }
    }
}
