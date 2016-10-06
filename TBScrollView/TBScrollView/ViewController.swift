//
//  ViewController.swift
//  TBScrollView
//
//  Created by 李童 on 2016/10/6.
//  Copyright © 2016年 李童. All rights reserved.
//

import UIKit

class TBRecommend: NSObject {
    var imageUrl: String
    var targetUrl: String
    init(img:String,url:String) {
        self.imageUrl = img
        self.targetUrl = url
    }
}
class ViewController: UIViewController,TBScrollViewDelegate {
    var scroll:TBScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scroll = TBScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200),delegate:self)
        scroll?.interval = 1
        self.view.addSubview(scroll!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let models = [TBRecommend(img: "0", url: ""),TBRecommend(img: "1", url: ""),TBRecommend(img: "2", url: ""),TBRecommend(img: "0", url: ""),TBRecommend(img: "1", url: ""),TBRecommend(img: "2", url: ""),TBRecommend(img: "0", url: "")]
    func numberInScroll() -> Int {
        return models.count
    }
    func itemOfIndex(index: Int, imageView: UIImageView) {
        let item = models[index]
        imageView.image = UIImage(named: item.imageUrl)
    }
    func didSelItem(index: Int) {
        print(index)
    }

}

