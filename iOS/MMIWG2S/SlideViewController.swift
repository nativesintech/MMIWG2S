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
    var bbView:UIView = BottomBannerView(frame: CGRect(x:0, y:0, width:0, height:0))
    var pc1View:UIView = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
    var pc2View:UIView = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
    var pc3View:UIView = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
    var pc4View:UIView = UIView(frame: CGRect(x:0, y:0, width:0, height:0))

    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:500, height:800))
    var pageControl = UIPageControl(frame:CGRect(x:200, y:700, width:200, height:50))
    var imageNames = (1...3).map{"image\($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageControl()
        scrollView.delegate = self
        scrollView.frame = view.frame
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        for index in 0..<3
        {
            print(imageNames[index])
            view.frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            view.frame.size = scrollView.frame.size
            let image = UIImage(named:imageNames[index])
            let imageView = UIImageView(image:image)
            imageView.frame = view.frame
            imageView.contentMode = .scaleAspectFill
            

            // let subView = UIView(frame:view.frame)
           // subView.addSubview(imageView)
            //subView.backgroundColor = colors[index]
            //imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            if index == 1 {
                let gradient = UIImage(named:"Rectangle1.png")
                let gradientView = UIImageView(image:gradient)
                gradientView.frame = view.frame
                gradientView.contentMode = .scaleAspectFill
                scrollView.addSubview(gradientView)
            }
             if index == 2 {
                 let gradient = UIImage(named:"Rectangle1-2.png")
                 let gradientView = UIImageView(image:gradient)
                 gradientView.frame = view.frame
                 gradientView.contentMode = .scaleAspectFill
                 scrollView.addSubview(gradientView)
             }

            scrollView.isPagingEnabled = true
            scrollView.contentSize = CGSize(width:scrollView.frame.width * 3, height:scrollView.frame.height)
            
            pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: .valueChanged)

            
            
            //pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

        }
/*
        scrollView.addConstraint(NSLayoutConstraint(item:scrollView, attribute:.leading, relatedBy:.equal, toItem:scrollView.subviews[0], attribute:.leading, multiplier:1, constant:0))
        
        scrollView.addConstraint(NSLayoutConstraint(item:scrollView.subviews[0], attribute:.trailing, relatedBy:.equal, toItem:scrollView.subviews[1], attribute:.leading, multiplier:1, constant:0))

        scrollView.addConstraint(NSLayoutConstraint(item:scrollView.subviews[1], attribute:.trailing, relatedBy:.equal, toItem:scrollView.subviews[2], attribute:.leading, multiplier:1, constant:0))
        
        scrollView.addConstraint(NSLayoutConstraint(item:scrollView.subviews[2], attribute:.leading, relatedBy:.equal, toItem:scrollView.subviews[2], attribute:.leading, multiplier:1, constant:0))

        scrollView.addConstraint(NSLayoutConstraint(item:scrollView, attribute:.top, relatedBy:.equal, toItem:scrollView.subviews[0], attribute:.top, multiplier:1, constant:0))

        scrollView.addConstraint(NSLayoutConstraint(item:scrollView, attribute:.top, relatedBy:.equal, toItem:scrollView.subviews[1], attribute:.top, multiplier:1, constant:0))

        scrollView.addConstraint(NSLayoutConstraint(item:scrollView, attribute:.top, relatedBy:.equal, toItem:scrollView.subviews[2], attribute:.top, multiplier:1, constant:0))

 */
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
        var labelMMIW = UILabel(frame:CGRect(x:0,y:0,width:50,height:21))
        var labelMMIWInfo = UILabel(frame:CGRect(x:0,y:0,width:200,height:200))
        var buttonNext = UIButton(frame:CGRect(x:0,y:0, width:30, height:17))


        labelMMIW.translatesAutoresizingMaskIntoConstraints = false
        labelMMIWInfo.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelMMIW)
        view.addSubview(labelMMIWInfo)

 //       view.addSubview(buttonNext)
        pc1View.translatesAutoresizingMaskIntoConstraints = false
//        buttonNext.addSubview(pc1View)
        pc2View.translatesAutoresizingMaskIntoConstraints = false
//        buttonNext.addSubview(pc2View)
        pc3View.translatesAutoresizingMaskIntoConstraints = false
//        buttonNext.addSubview(pc3View)
        pc4View.translatesAutoresizingMaskIntoConstraints = false
//        buttonNext.addSubview(pc4View)

        
        labelMMIW.textAlignment = .center
        labelMMIW.text = "#MMIW"
        labelMMIW.textColor = UIColor.white
        labelMMIW.font = UIFont(name: "Verdana-Bold", size:36.0 )

        //labelMMIWInfo.textAlignment = .center
        labelMMIWInfo.numberOfLines = 0
        labelMMIWInfo.textColor = UIColor.white
        labelMMIWInfo.font = UIFont(name: "Verdana", size:25.0 )
        labelMMIWInfo.text = "On some reservations, native women are murdered at a rate 10 times the national average."

        pc1View.backgroundColor = UIColor.red
        pc2View.backgroundColor = UIColor.white
        pc3View.backgroundColor = UIColor.white
        pc4View.backgroundColor = UIColor.white
        //labelMMIWInfo.backgroundColor = UIColor.red
        
        buttonNext.alpha = 1.0
        buttonNext.setTitleColor(UIColor.white, for:.normal)
        buttonNext.setTitleColor(UIColor.green, for:.selected)

        buttonNext.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:0 )
        buttonNext.contentEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:0 )
        buttonNext.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buttonNext.setTitle("Next", for:.normal)
        
        pageControl.currentPage += pageControl.currentPage

        buttonNext.addTarget(self, action: #selector(self.changePage(sender:)), for: .touchUpInside)
        
        let bottomView = UIView(frame:CGRect(x:0, y:0, width:100, height:50))
        bottomView.addSubview(pc1View)
        bottomView.addSubview(pc2View)
        bottomView.addSubview(pc3View)
        bottomView.addSubview(pc4View)
        bottomView.addSubview(buttonNext)
        //let gr = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))

        let gr = UITapGestureRecognizer(target: self, action: #selector(self.changePage(sender:)))

        bottomView.isUserInteractionEnabled = true
        bottomView.addGestureRecognizer(gr)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        
        
        var views: [String:Any] = ["labelMMIW":labelMMIW, "labelMMIWInfo":labelMMIWInfo, "bottomView":bottomView]

/*        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[labelMMIW(50)]->=0-[labelMMIWInfo(160)]-12-[buttonNext(17)]-36-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
*/
        
        /*   independent uiviews original constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[labelMMIW(50)]->=0-[labelMMIWInfo(160)]-12-[pc1View(15)]-36-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[labelMMIW(50)]->=0-[labelMMIWInfo(160)]-12-[pc2View(15)]-36-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[labelMMIW(50)]->=0-[labelMMIWInfo(160)]-12-[pc3View(15)]-36-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[labelMMIW(50)]->=0-[labelMMIWInfo(160)]-12-[pc4View(15)]-36-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
*/

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-36-[labelMMIW]-56-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["labelMMIW":labelMMIW]))
 
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[labelMMIWInfo]-25-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["labelMMIWInfo":labelMMIWInfo]))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[labelMMIW(50)]->=0-[labelMMIWInfo(160)]-12-[bottomView(17)]-36-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        // page control and button constraints

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=0-[bottomView(70)]-10-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
       
        views = ["pc1View":pc1View, "pc2View":pc2View, "pc3View":pc3View, "pc4View":pc4View, "buttonNext":buttonNext]

    // bottomView constraints
        
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc1View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc2View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc3View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc4View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[buttonNext(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=0-[pc1View(2)]-2-[pc2View(2)]-2-[pc3View(2)]-2-[pc4View(2)]-2-[buttonNext(45)]|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        
        
        // button constraints
        
/*        buttonNext.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc1View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        buttonNext.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc2View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        buttonNext.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc3View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        buttonNext.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[pc4View(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        buttonNext.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=0-[titleLabel(15)]-2-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))

        buttonNext.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=0-[pc1View(2)]-2-[pc2View(2)]-2-[pc3View(2)]-2-[pc4View(2)]-2-[titleLabel(45)]->=0-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
 */
/*
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|->=0-[pc1View(2)]-2-[pc2View(2)]-2-[pc3View(2)]-2-[pc4View(2)]-4-[buttonNext(40)]-27-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
*/
        //Setup Constraints
 /*
        let views: [String:Any] = ["tbView":tbView, "bbView":bbView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[tbView(100)]->=0-[bbView(100)]-40-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views:views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tbView]-10-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["tbView":self.tbView]))

        //self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bbView(100)]-40-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["bbView":self.bbView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[bbView]-10-|", options:NSLayoutConstraint.FormatOptions.init(rawValue:0), metrics:nil, views: ["bbView":self.bbView]))
*/


 /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }
    
    func buttonClicked(sender: UIButton!)
    {
        
        
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer)
    {
        print("test")
    }
}
