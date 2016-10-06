//
//  TBScrollView.swift
//  TaobaoApp
//
//  Created by 李童 on 2016/9/28.
//  Copyright © 2016年 李童. All rights reserved.
//

import UIKit

class RecommendView:UIControl{
    var image:UIImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[image]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["image" : image]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[image]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["image" : image]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objc protocol TBScrollViewDelegate:NSObjectProtocol {
    func numberInScroll()->Int
    func itemOfIndex(index:Int,imageView:UIImageView)
    @objc optional func didSelItem(index:Int)
}
class TBScrollView: UIView {
    var itemCount:Int = 0
    var currentIndex = 0
    //自动滚动时间间隔
    var interval:TimeInterval = 0 {
        didSet{
            if interval > 0{
                self.setTimer()
            }
        }
    }
    weak var delegate:TBScrollViewDelegate?
    
    var scrollView:UIScrollView = UIScrollView()
    var pageControll:UIPageControl = UIPageControl()
    
    var leftView:RecommendView = RecommendView()
    var centerView:RecommendView = RecommendView()
    var rightView:RecommendView = RecommendView()
    
    var timer:Timer?
    //初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(frame:CGRect,delegate:TBScrollViewDelegate){
        self.init(frame:frame)
        self.delegate = delegate
        self.frame = frame
        itemCount = self.delegate?.numberInScroll() ?? 0
        setUI()
    }
    //初始化UI
    func setUI(){
        scrollView.frame = self.frame
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        pageControll.numberOfPages = itemCount
        pageControll.pageIndicatorTintColor = UIColor.gray
        pageControll.currentPageIndicatorTintColor = UIColor.orange
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageControll)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pageControll]-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["pageControll" : pageControll]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pageControll]|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["pageControll" : pageControll]))
        
        
        setContentView()
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
        
        delegate?.itemOfIndex(index: currentIndex, imageView: centerView.image)

    }
    deinit {
        timer?.invalidate()
        timer = nil
    }
    //自动滚动放方法
    func autoScroll(){
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * 2, y: 0), animated: true)
    }
    //设置内容View
    func setContentView(){
        let size = scrollView.frame.size
        
        leftView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.addSubview(leftView)
        leftView.addTarget(self, action: #selector(didSelItem), for: UIControlEvents.touchUpInside)
        leftView.addTarget(self, action: #selector(touchDownItem), for: UIControlEvents.touchDown)
        leftView.addTarget(self, action: #selector(touchUpOutSideItem), for: UIControlEvents.touchUpOutside)

        centerView.frame = CGRect(x: size.width, y: 0, width: size.width, height: size.height)
        scrollView.addSubview(centerView)
        centerView.addTarget(self, action: #selector(didSelItem), for: UIControlEvents.touchUpInside)
        centerView.addTarget(self, action: #selector(touchDownItem), for: UIControlEvents.touchDown)
        centerView.addTarget(self, action: #selector(touchUpOutSideItem), for: UIControlEvents.touchUpOutside)

        
        rightView.frame = CGRect(x: size.width * 2, y: 0, width: size.width, height: size.height)
        scrollView.addSubview(rightView)
        rightView.addTarget(self, action: #selector(didSelItem), for: UIControlEvents.touchUpInside)
        rightView.addTarget(self, action: #selector(touchDownItem), for: UIControlEvents.touchDown)
        rightView.addTarget(self, action: #selector(touchUpOutSideItem), for: UIControlEvents.touchUpOutside)

        
        scrollView.contentSize = CGSize(width: size.width * 3, height: size.height)
        
        
    }
    //按下时暂停滚动
    func touchDownItem(){
        if timer != nil && timer!.isValid{
            timer?.invalidate()
            timer = nil
        }
    }
    func touchUpOutSideItem(){
        if interval > 0{
            setTimer()
        }
    }
    func didSelItem(){
        self.touchUpOutSideItem()
        delegate?.didSelItem?(index: currentIndex)
        
    }
    //开始自动滚动
    func setTimer(){
        if timer != nil && timer!.isValid{
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    //
    func setScrollContentOffset(){
        
        if interval > 0 {
            self.setTimer()
        }
        let pageWidth = scrollView.frame.size.width
        let page = scrollView.contentOffset.x / pageWidth
        
        if page == 0.0 {//向左滑动
            
            currentIndex = currentIndex - 1
            if currentIndex < 0 {
                currentIndex = itemCount - 1
            }
            rightView.frame.origin.x = 0
            leftView.frame.origin.x = pageWidth
            centerView.frame.origin.x = pageWidth * 2
            let tem = rightView
            rightView = centerView
            centerView = leftView
            leftView = tem
        }else if page == 1.0{
            return
        }else{//向右滑动
            currentIndex = currentIndex + 1
            if currentIndex == itemCount {
                currentIndex = 0
            }
            centerView.frame.origin.x = 0
            rightView.frame.origin.x = pageWidth
            leftView.frame.origin.x = pageWidth * 2
            let tem = leftView
            leftView = centerView
            centerView = rightView
            rightView = tem
        }
        pageControll.currentPage = currentIndex
        delegate?.itemOfIndex(index: currentIndex, imageView: centerView.image)
        
        var rightIndex = currentIndex + 1
        if rightIndex == itemCount {
            rightIndex = 0
        }
        delegate?.itemOfIndex(index: rightIndex, imageView: rightView.image)
        
        var leftIndex = currentIndex - 1
        if leftIndex < 0 {
            leftIndex = itemCount - 1
        }
        delegate?.itemOfIndex(index: leftIndex, imageView: leftView.image)
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TBScrollView:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setScrollContentOffset()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setScrollContentOffset()
    }
    
}
