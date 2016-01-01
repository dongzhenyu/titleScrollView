//
//  NewsViewController.m
//  网易新闻
//
//  Created by dzy on 16/1/1.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "NewsViewController.h"


static CGFloat const NavBarH = 64;
static CGFloat const titleScrollViewH = 44;
static CGFloat const btnW = 100;
static CGFloat const titleScale = 1.3;

#define DZYScreenW [UIScreen mainScreen].bounds.size.width
#define DZYScreenH [UIScreen mainScreen].bounds.size.height

@interface NewsViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
/** 选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 所有按钮的数组 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtons;

@property (nonatomic, assign) BOOL isInitial;

@end

@implementation NewsViewController

#pragma mark - lazy
- (NSMutableArray<UIButton *> *)titleButtons
{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.添加标题滚动视图
    [self setupTitleScrollView];
    // 2.添加内容滚动视图
    [self setupContentScrollView];

    // 5.监听按钮点击 切换页面
    // 1.标题颜色变成红色
    // 2.把对应子控制器的view添加到对应位置
    // 3.让内容的view滚动到指定位置
    
    // 取消自动添加的额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 6.滚动完成做的事情
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isInitial) {
        // 4.添加所有的标题
        [self setupAllTitleButton];
        _isInitial = YES;
    }
}

//// 在viewDidAppear里面打印导航控制器的栈顶控制器View的frame
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
////    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//}

// 1.添加标题滚动视图
- (void)setupTitleScrollView
{
    // 1.创建标题视图
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    CGFloat titleScrollViewX = 0;
    CGFloat titleScrollViewY = self.navigationController ? NavBarH : 0;
    CGFloat titleScrollViewW = DZYScreenW;
    titleScrollView.frame = CGRectMake(titleScrollViewX, titleScrollViewY, titleScrollViewW, titleScrollViewH);
    
//    titleScrollView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
}

// 2.添加内容滚动视图
- (void)setupContentScrollView
{
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat contentScrollViewX = 0;
    CGFloat contentScrollViewY = CGRectGetMaxY(self.titleScrollView.frame);
    CGFloat contentScrollViewW = DZYScreenW;
    CGFloat contentScrollViewH = DZYScreenH - contentScrollViewY;
    contentScrollView.frame = CGRectMake(contentScrollViewX, contentScrollViewY, contentScrollViewW, contentScrollViewH);
    
    contentScrollView.delegate = self;
    
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
}


// 4.添加所有的标题
- (void)setupAllTitleButton
{
    // 获得子控制器总数
    NSInteger count = self.childViewControllers.count;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnH = titleScrollViewH;
    
    // 遍历所有子控制器,添加标题
    for (int i = 0; i<count; i++) {
        // 创建标题按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.tag = i;
        [self.titleScrollView addSubview:btn];
        // 设置标题内容
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 监听按钮的点击
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchDown];
        
        // 默认选中第0个按钮
        if (i == 0) {
            [self titleClick:btn];
        }
        
        // 保存到对应的数组中
        [self.titleButtons addObject:btn];
    }
    /*
     出现的问题:titleScrollView不能滚动,标题颜色默认为黑色,隐藏titleScrollView的水平指示条
     */
    // 设置标题滚动条的滚动范围
    CGFloat contentW = count * btnW;
    self.titleScrollView.contentSize = CGSizeMake(contentW, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置内容滚动范围
    self.contentScrollView.contentSize = CGSizeMake(count * DZYScreenW, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
}

// 5.按钮点击
- (void)titleClick:(UIButton *)button
{
    // 获取角标
    NSInteger i = button.tag;
    
    // 让标题选中
    [self selectedTitleButton:button];
    
    // 把对应控制器的view添加到对应位置
    CGFloat x = i * DZYScreenW;
    [self setupChildViewController:i];
    
    // 让内容view滚动到指定位置
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    /*
     问题:1.但是内容滚动view不能滚动
     2.隐藏水平指示器
     3.内容滚动view(UIScrollView)里面所有子控件,都往下偏移64
     4.开启分页,取消弹簧效果
     5.默认选中第0个
     
     iOS7下,导航控制器下scrollView顶部都会添加额外滚动区域64
     */
    
    // 让标题居中
}

// 5.1选中按钮
- (void)selectedTitleButton:(UIButton *)btn
{
    // 恢复上一个按钮颜色
    [self.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 恢复上一个形变
    self.selectedButton.transform = CGAffineTransformIdentity;
    
    // 设置当前选中按钮颜色
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    // 让标题缩放
    btn.transform = CGAffineTransformMakeScale(titleScale, titleScale);
    
    // 记录当前选中按钮
    self.selectedButton = btn;
    // 让标题居中
    [self setupTitleCenter:btn];
    // 设置标题缩放 (改字体或者形变)
//    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    
}

// 让标题选中
- (void)setupTitleCenter:(UIButton *)button
{
    // 怎么让标题居中,移动偏移量
    CGFloat offsetX = button.center.x - DZYScreenW * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - DZYScreenW;
    // 判断下是否大于最大的滚动范围
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 设置偏移量
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
//    NSLog(@"%f", offsetX);
}

// 5.2添加子控制view
- (void)setupChildViewController:(NSInteger)i
{
    // 取出对应的子控制器(不用每次都加载一次,判断一下它有没有父控件有就不加载了)
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) return;
    
    CGFloat x = i * DZYScreenW;
    CGFloat y = 0;
    CGFloat w = DZYScreenW;
    CGFloat h = self.contentScrollView.bounds.size.height;
//    UIViewController *vc = self.childViewControllers[i];
    vc.view.frame = CGRectMake(x, y, w, h);
    [self.contentScrollView addSubview:vc.view];
}

#pragma mark - UIScrollViewDelegate
// 6.滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%s", __func__);
    
    // 当前的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前页码
    NSInteger i = offsetX / DZYScreenW;
    
    // 0.获取选中的按钮
    UIButton *button = self.titleButtons[i];
    // 1.选中对应的标题按钮
    [self selectedTitleButton:button];
    // 2.把对应的子控制器的view添加上去,显示出来
    [self setupChildViewController:i];
    // 3.让标题居中
}

// 只要滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger count = self.titleButtons.count;
    // 缩放标题
    // 确定那两个标题进行缩放
    NSInteger leftI = scrollView.contentOffset.x / DZYScreenW;
    NSInteger rightI = leftI + 1;
    // 1.获取左边按钮
    UIButton *leftBtn = self.titleButtons[leftI];
    // 2.获取右边按钮 0 ~5
    UIButton *rightBtn;
    // 6
    if (rightI < count) {
        rightBtn = self.titleButtons[rightI];
    }
    // 3.形变按钮
    // 3.1计算缩放比例
    CGFloat scaleR = scrollView.contentOffset.x / DZYScreenW - leftI;
    CGFloat scaleL = 1- scaleR;
    
    // 0 ~ 1 1~ 1.3
    CGFloat transformScale = titleScale - 1;
    
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * transformScale + 1, scaleL * transformScale + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * transformScale + 1, scaleR * transformScale + 1);
    
    // 4.标题颜色渐变
    // 4.1获取右边按钮颜色
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    /*
     颜色由  R G B 组成
        黑色:0 0 0
        红色:1 0 0
        白色:1 1 1
     */
}


@end
