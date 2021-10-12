//
//  IntroViewController.swift
//  
//
//  Created by Mark Amaro on 12/3/20.
//

import UIKit

class IntroViewController: UIViewController {
    var delegate: NextPageDelegate?
    let background: UIImage
    let gradient: UIImage
    let mmiwtext: String
    let page: Int
    
    
    // This allows you to initialise your custom UIViewController without a nib or bundle.
    
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
        
        setupUI()
    }
    
    
    func setupUI() {
        
        //Setup UI
        let labelMMIW = UILabel()
        let labelMMIWInfo = UILabel()
        let buttonNext = UIButton()
        
        let spacerView1 = UIView()
        let spacerView2 = UIView()
        
        labelMMIW.translatesAutoresizingMaskIntoConstraints = false
        spacerView1.translatesAutoresizingMaskIntoConstraints = false
        
        labelMMIWInfo.translatesAutoresizingMaskIntoConstraints = false
        spacerView2.translatesAutoresizingMaskIntoConstraints = false
        
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(labelMMIW)
        view.addSubview(labelMMIWInfo)
        view.addSubview(spacerView1)
        
        let pageControlViews: [UIView] = [UIView(), UIView(), UIView(), UIView()]
        
        guard page < pageControlViews.count else {
            print("page is outside pageControlViews ")
            return
        }
        pageControlViews.forEach {
            $0.backgroundColor = .white
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        labelMMIW.textAlignment = .center
        labelMMIW.text = .slideviewheader
        labelMMIW.textColor = .white
        labelMMIW.font = .roboto36
        
        labelMMIWInfo.numberOfLines = 0
        labelMMIWInfo.textColor = UIColor.white
        labelMMIWInfo.font = .roboto24
        labelMMIWInfo.text = mmiwtext
        //initialize pcs
        
        pageControlViews[page].backgroundColor = .red
        
        buttonNext.setTitleColor(UIColor.white, for:.normal)
        buttonNext.setTitleColor(UIColor.green, for:.selected)
        
        buttonNext.imageEdgeInsets = .zero
        buttonNext.contentEdgeInsets = .zero
        buttonNext.titleLabel?.font = .roboto17
        buttonNext.setTitle(String.next, for:.normal)
        
        buttonNext.addTarget(self, action: #selector(self.changePage(sender:)), for: .touchUpInside)
        
        let bottomView = UIView(frame:.zero)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        pageControlViews.forEach { bottomView.addSubview($0) }
        
        bottomView.addSubview(buttonNext)
        
        let gesturerecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changePage(sender:)))
        
        bottomView.isUserInteractionEnabled = true
        bottomView.addGestureRecognizer(gesturerecognizer)
        
        view.addSubview(bottomView)
        view.addSubview(spacerView2)
        
        let constraints = [
            labelMMIW.heightAnchor.constraint(equalToConstant: 50),
            labelMMIW.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            labelMMIW.centerXAnchor.constraint(equalTo:self.view.centerXAnchor),
            labelMMIWInfo.heightAnchor.constraint(equalToConstant: 150),
            labelMMIWInfo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25),
            labelMMIWInfo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25),
            labelMMIWInfo.bottomAnchor.constraint(equalTo: spacerView1.topAnchor, constant:0),
            labelMMIWInfo.centerXAnchor.constraint(equalTo:self.view.centerXAnchor),
            spacerView1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25),
            spacerView1.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25),
            spacerView1.heightAnchor.constraint(equalToConstant:0),
            spacerView1.bottomAnchor.constraint(equalTo:bottomView.topAnchor, constant:0),
            bottomView.widthAnchor.constraint(equalToConstant: 100),
            bottomView.heightAnchor.constraint(equalToConstant: 55),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            bottomView.bottomAnchor.constraint(equalTo: spacerView2.topAnchor, constant:0),
            spacerView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant:25),
            spacerView2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant:-25),
            
            spacerView2.heightAnchor.constraint(equalToConstant:0),
            spacerView2.bottomAnchor.constraint(equalTo:self.view.bottomAnchor, constant:0),
            
            buttonNext.widthAnchor.constraint(equalToConstant: 45),
            buttonNext.heightAnchor.constraint(equalToConstant: 15),
            buttonNext.centerYAnchor.constraint(equalTo:bottomView.centerYAnchor),
            buttonNext.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        // page control and button constraints
        let leftMostTrailingPadding: CGFloat = 61
        for (i, pageControlView) in pageControlViews.enumerated() {
            pageControlView.heightAnchor.constraint(equalToConstant: 15).isActive = true
            pageControlView.centerYAnchor.constraint(equalTo:bottomView.centerYAnchor).isActive = true
            let trailingPadding = CGFloat(i) * 4 - leftMostTrailingPadding
            pageControlView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: trailingPadding).isActive = true
            pageControlView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        }
    }
    
    @objc func changePage(sender: AnyObject) {
        if (delegate != nil) {
            delegate?.nextSlide(page)
        }
    }
    
}
