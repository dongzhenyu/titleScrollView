//
//  WYNewsViewController.m
//  网易新闻
//
//  Created by dzy on 16/1/2.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "WYNewsViewController.h"
#import "TopViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocietyViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

@interface WYNewsViewController ()

@end

@implementation WYNewsViewController

// 提高代码的复用性

/**
 *  有多少个子控制有子类决定
 */
- (void)viewDidLoad {

    [super viewDidLoad];
    
    // 3.添加所有的子控制器,有多少子控制器就有多少标题
    [self setupAllChildViewController];
    
}

// 3.添加所有的子控制器
- (void)setupAllChildViewController
{
    TopViewController *topVc = [[TopViewController alloc] init];
    topVc.title = @"头条";
    [self addChildViewController:topVc];
    
    HotViewController *hotVc = [[HotViewController alloc] init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
    VideoViewController *videoVc = [[VideoViewController alloc] init];
    videoVc.title = @"视频";
    [self addChildViewController:videoVc];
    
    SocietyViewController *societyVc = [[SocietyViewController alloc] init];
    societyVc.title = @"社会";
    [self addChildViewController:societyVc];
    
    ReaderViewController *readerVc = [[ReaderViewController alloc] init];
    readerVc.title = @"阅读";
    [self addChildViewController:readerVc];
    
    ScienceViewController *scienceVc = [[ScienceViewController alloc] init];
    scienceVc.title = @"科技";
    [self addChildViewController:scienceVc];
}


@end
