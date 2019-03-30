#目录
1、CJRadioButtons
单选按钮的组合

2、CJCycleComposeView
单选视图

3、CJButtonControllerView
类似网易新闻左右滑动的控制器的“父类”（为1和2的结合使用）


循环滚动的视图组合

* 方案①：5 1 2 3 4 5 1
* 方案②：Left:center:right:
* 方案③：SDCycleScrollView

其他参考：[图片轮播图浅析](http://www.2cto.com/kf/201606/517055.html)


## 一、CJRadioButtons
单选按钮的组合

#### Screenshots
![Example](./Screenshots/RadioButtons_Slider.gif "组合按钮+滑动")
![Example](./Screenshots/RadioButtons_DropDown.gif "组合按钮+下拉")
![Example](./Screenshots/RadioButtons_Slider.png "组合按钮+滑动")
![Example](./Screenshots/RadioButtons_DropDown.png "组合按钮+下拉")

#### How to use
- RadioButtons（"组合按钮"）的使用

```
//①、初始化如下：
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.titles =  @[@"Home1第一页", @"Home2", @"Home3是佛恩", @"Home4天赐的爱", @"Home5你是礼物", @"Home6", @"Home7", @"Home8", @"Home9", @"Home10", @"Home11", @"Home12", @"Home13", @"Home14", @"Home15"];

    self.sliderRadioButtons.dataSource = self;
    self.sliderRadioButtons.delegate = self;
}


//②实现数据源 `RadioButtonsDataSource `
- (NSInteger)cj_numberOfComponentsInRadioButtons:(RadioButtons *)radioButtons {
    return self.titles.count;
}

- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index  {
    NSInteger showViewCount = 6;
    CGFloat sectionWidth = CGRectGetWidth(radioButtons.frame)/showViewCount;
    return ceilf(sectionWidth); 
}

- (RadioButton *)cj_radioButtons:(RadioButtons *)radioButtons cellForComponentAtIndex:(NSInteger)index {
    NSArray *radioButtonNib = [[NSBundle mainBundle]loadNibNamed:@"RadioButton_Slider" owner:nil options:nil];
    RadioButton *radioButton = [radioButtonNib lastObject];
    [radioButton setTitle:self.titles[index]];
    radioButton.textNormalColor = [UIColor blackColor];
    radioButton.textSelectedColor = [UIColor greenColor];
    
    return radioButton;
}

//③实现数据委托 `RadioButtonsDelegate`
- (void)cj_radioButtons:(RadioButtons *)radioButtons chooseIndex:(NSInteger)index_cur oldIndex:(NSInteger)index_old {
    NSLog(@"index_old = %ld, index_cur = %ld", index_old, index_cur);
}

```

** 重点注意 **：`- (CGFloat)cj_radioButtons:(RadioButtons *)radioButtons widthForComponentAtIndex:(NSInteger)index`中的宽度计算若是通过除法得来，
即当使用除法计算width时候，为了避免计算出来的值受除后，余数太多，除不尽(eg:102.66666666666667)，而造成的之后在通过左右箭头点击来寻找”要找的按钮“的时候，计算出现问题（”要找的按钮“需与“左右侧箭头的最左最右侧值”进行精确的比较），所以这里我们需要一个整数值，故我们这边选择向上取整。


## 二、CJCycleComposeView
```
//1、初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.componentViewControllers = [self getComponentViewControllers];
    
    self.radioComposeView.dataSource = self;
    self.radioComposeView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.radioComposeView scrollToCenterViewWithAnimate:NO];
}
```

```
//2、实现数据源 `RadioComposeViewDataSource`
- (NSArray<UIView *> *)cj_radioViewsInRadioComposeView:(RadioComposeView *)radioComposeView {
    NSArray *componentViewControllers = self.componentViewControllers;
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIViewController *vc in componentViewControllers) {
        [views addObject:vc.view];
        [self addChildViewController:vc];//记得添加进去
    }
    
    return views;
}
```

```
//3、实现数据委托 `RadioComposeViewDelegate`
- (void)cj_radioComposeView:(RadioComposeView *)radioComposeView didChangeToIndex:(NSInteger)index {
    NSLog(@"点击了%ld", index);
}


```


## 三、CJButtonControllerView
类似网易新闻左右滑动的控制器的“父类”


#### ScrollView循环滚动的原理
**原理：**初始化的时候，生成左·中·右视图，并为左·中·右视图附上正确的视图内容。之后，就是滚动的时候的处理了。这里滚动的时候的处理为：正在滚动过程中，滚动看到的视图，还是这一次生成的视图。但是滚动结束后，我们需要进行一次`偷梁换柱`即：滚动结束后，把这一次左·中·右视图上的视图，全部remove掉，并且为左·中·右视图重新附上新的视图，同时将scrollView滚动到这一次视图应该滚动到的位置，也就是为中视图的位置。这样就会让用户看不出来，其实我们已经进行了一次视图的重新改变，只是改变后显示的内容位置刚刚好覆盖住了上一次的内容，而让用户察觉不到，最终大功告成。

```
//①、初始化
@property (nonatomic, strong) IBOutlet CJButtonControllerView *buttonControllerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.buttonControllerView.titles =  @[@"Home1第一页", @"Home2", @"Home3是佛恩", @"Home4天赐的爱", @"Home5你是礼物", @"Home6"];
    self.buttonControllerView.componentViewControllers = [self getComponentViewControllers];
    self.buttonControllerView.componentViewParentViewController = self;
    
    self.buttonControllerView.dataSource = self;
    self.buttonControllerView.delegate = self;
    [self.buttonControllerView reloadData];
}

```

```
②实现数据源 `CJButtonControllerViewDataSource`
- (RadioButton *)cj_buttonControllerView:(CJButtonControllerView *)buttonControllerView cellForComponentAtIndex:(NSInteger)index {
    NSArray *radioButtonNib = [[NSBundle mainBundle]loadNibNamed:@"RadioButton_Slider" owner:nil options:nil];
    RadioButton *radioButton = [radioButtonNib lastObject];
    
    radioButton.textNormalColor = [UIColor blackColor];
    radioButton.textSelectedColor = [UIColor whiteColor];
    
    return radioButton;
}
```

```
//③实现数据委托 `CJButtonControllerViewDelegate`
- (void)cj_buttonControllerView:(CJButtonControllerView *)buttonControllerView didChangeToIndex:(NSInteger)index {
    NSLog(@"didChangeToIndex = %ld", index);
}
```

#### 完



