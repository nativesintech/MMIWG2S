//
//  CaptionPickerView.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 4/24/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import UIKit

class CaptionPickerView: UIView {
    private let titles: [String] = (1...4).compactMap { .statistic(number: $0) }
    private let pageControlBottomPadding: CGFloat = 20
    private let labelViewBottomPadding: CGFloat = 40
    private let labelViewHeight: CGFloat = 130
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let stackView = UIStackView()
    
    private var labels = [UILabel]()
    
    convenience init() {
        self.init(frame: .zero)
        addBackground()
        setupContent()
    }
    
    func asImageWithoutPaginationIndicator() -> UIImage {
        if Thread.isMainThread {
            pageControl.isHidden = true
        } else {
            DispatchQueue.main.sync {
                pageControl.isHidden = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
            self?.pageControl.isHidden = false
        })
        return asImage()
    }
    
    private func addBackground() {
        let background = UIImageView(image: UIImage(named: "gradient1"))
        background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.contentMode = .scaleToFill
        background.clipsToBounds = true
        
        addSubview(background)
        background.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        background.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupContent() {
        labels = titles.compactMap {
            log.info("setting up label for \($0)")
            let label = UILabel()
            label.text = $0
            label.textAlignment = .center
            label.numberOfLines = 3
            label.lineBreakMode = .byWordWrapping
            label.font = .roboto24
            label.textColor = .white
            return label
        }
        
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(labels.count), height: frame.height)
        
        pageControl.numberOfPages = labels.count
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)

        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -pageControlBottomPadding).isActive = true

        labels.forEach { label in
            let labelContentView = UIView()
            stackView.addArrangedSubview(labelContentView)
            label.translatesAutoresizingMaskIntoConstraints = false
            labelContentView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            labelContentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true


            labelContentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: labelViewHeight).isActive = true
            label.bottomAnchor.constraint(equalTo: labelContentView.bottomAnchor, constant: -labelViewBottomPadding).isActive = true
            label.centerXAnchor.constraint(equalTo: labelContentView.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        scrollView.scrollRectToVisible(labels[pageControl.currentPage].frame, animated: true)
    }
}

extension CaptionPickerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / frame.width)
    }
}
