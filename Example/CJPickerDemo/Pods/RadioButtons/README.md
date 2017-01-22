# RadioButtons
单选按钮的组合（包含①RadioButtons_Slider"组合按钮+滑动"和RadioButtons_DropDown"组合按钮+下拉"）

## Screenshots
![Example](./Screenshots/RadioButtons_Slider.gif "组合按钮+滑动")
![Example](./Screenshots/RadioButtons_DropDown.gif "组合按钮+下拉")
![Example](./Screenshots/RadioButtons_Slider.png "组合按钮+滑动")
![Example](./Screenshots/RadioButtons_DropDown.png "组合按钮+下拉")

## How to use
- ①、RadioButtons_Slider（"组合按钮+滑动"）的使用
```
//初始化如下：
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor greenColor];

    #pragma mark 此例中如果RBSlierVC.xib没有去掉sizeClasses，则容易出现视图无显示问题
    RadioButtons_Slider *rb_slider = [[RadioButtons_Slider alloc]initWithFrame:CGRectMake(0, 100, 320, 40)];
    NSArray *radioButtonNames =  @[@"Home1第一页", @"Home2", @"Home3是佛恩", @"Home4天赐的爱", @"Home5你是礼物", @"Home6"];
    [rb_slider setTitles:radioButtonNames radioButtonNidName:@"RadioButton_Slider" andShowIndex:4];
    [rb_slider setDelegate:self];
    [self.view addSubview:rb_slider];
}

//点击时候会调用如下委托：
- (void)radioButtons:(RadioButtons_Slider *)radioButtons chooseIndex:(NSInteger)index{
    NSLog(@"当前选择的是%d", index);

}

```


- ②、RadioButtons_DropDown（"组合按钮+下拉"）的使用
```
//初始化如下：
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    #pragma mark 此例中如果RBDropDownVC.xib没有去掉sizeClasses，则容易出现视图无显示问题
    CGRect rect_rbDropDwon1 = CGRectMake(0, 164, 320, 40);
    RadioButtons_DropDown *rb_dropdown1 = [[RadioButtons_DropDown alloc]initWithFrame:rect_rbDropDwon1];
    [rb_dropdown1 setTitles:@[@"人物", @"爱好", @"其他", @"地区"] radioButtonNidName:@"RadioButton_DropDown"];
    rb_dropdown1.delegate = self;
    rb_dropdown1.tag = 111;
    [self.view addSubview:rb_dropdown1];
}

//点击时候会调用如下委托：
- (void)radioButtons:(RadioButtons_DropDown *)radioButtons chooseIndex:(NSInteger)index{
    NSLog(@"当前选择的是%d", index);

    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    customView.backgroundColor = [UIColor greenColor];
    [radioButtons showDropDownExtendView:customView inView:self.view complete:nil];//弹出下拉视图
}
```


- ②、xxxx的使用
```

```




