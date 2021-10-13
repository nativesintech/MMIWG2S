//
//  IntroViewController.swift
//  
//
//  Created by Mark Amaro on 12/3/20.
//

import UIKit

class IntroViewController: UIViewController {
    let background: UIImage
    let gradient: UIImage
    let mmiwtext: String
    let page: Int
    
    init(background: UIImage, gradient: UIImage, mmiwtext: String, page: Int) {
        self.mmiwtext = mmiwtext
        self.background = background
        self.page = page
        self.gradient = gradient
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        let image = background
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let gradient = self.gradient
        let gradientView = UIImageView(image: gradient)
        gradientView.frame = view.frame
        gradientView.contentMode = .scaleAspectFill
        gradientView.clipsToBounds = true
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.widthAnchor.constraint(equalTo: view.widthAnchor),
            gradientView.heightAnchor.constraint(equalTo: view.heightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let labelMMIWInfo = UILabel()
        labelMMIWInfo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelMMIWInfo)
        labelMMIWInfo.numberOfLines = 0
        labelMMIWInfo.textColor = UIColor.white
        labelMMIWInfo.font = .roboto24
        labelMMIWInfo.text = mmiwtext
        
        NSLayoutConstraint.activate([
            labelMMIWInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            labelMMIWInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            labelMMIWInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48),
            labelMMIWInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
