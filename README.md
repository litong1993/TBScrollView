# TBScrollView
可循环自动滚动的ScrollViwe
# 使用方法

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //初始化
    scroll = TBScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200),delegate:self)
    //设置自动滚动的时间
    scroll?.interval = 1
    self.view.addSubview(scroll!)

}
```

# 代理方法
```swift
//设置内容数量
func numberInScroll() -> Int {
    return models.count
}
//设置内容图片
func itemOfIndex(index: Int, imageView: UIImageView) {
    let item = models[index]
    imageView.image = UIImage(named: item.imageUrl)
}
//点击事件
func didSelItem(index: Int) {
    print(index)
}
```
