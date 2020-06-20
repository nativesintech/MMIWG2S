//
//  SlideViewController.swift
//  MMIWG2S
//
//  Created by Marvin Amaro on 6/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController, UIScrollViewDelegate {

    var tbView:TopBannerView = TopBannerView(frame: CGRect(x:0, y:0, width:0, height:0))
    var bbView:BottomBannerView = BottomBannerView(frame: CGRect(x:0, y:0, width:0, height:0))
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:500, height:800))
    var pageControl = UIPageControl(frame:CGRect(x:200, y:700, width:200, height:50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageControl()
        scrollView.delegate = self
        view.addSubview(scrollView)
        for index in 0..<4
        {
            view.frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            view.frame.size = scrollView.frame.size
            let subView = UIView(frame:view.frame)
            subView.backgroundColor = colors[index]
            scrollView.addSubview(subView)
            scrollView.isPagingEnabled = true
            scrollView.contentSize = CGSize(width:scrollView.frame.width * 4, height:scrollView.frame.height)
            pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: .valueChanged)
        //pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

        }
        //view.backgroundColor = UIColor(red:50/255, green:0, blue:12.5/255, alpha:1.0)
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @objc func changePage(sender:AnyObject) ->()
    {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated:true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView:UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func configurePageControl()
    {
        pageControl.numberOfPages = colors.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.green
        view.addSubview(pageControl)
    }
    
    func setupUI()
    {   
        //Setup UI
        tbView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tbView)
        bbView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bbView)
        
        //Setup Constraints
        
        let views: [String:Any] = ["tbView":tbView, "bbView":bbView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[tbView(100)]->=0-[bbView(100)]-40-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tbView]-10-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["tbView":self.tbView]))

        //self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bbView(100)]-40-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["bbView":self.bbView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[bbView]-10-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["bbView":self.bbView]))

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
