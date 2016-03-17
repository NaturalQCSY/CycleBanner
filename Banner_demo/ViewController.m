//
//  ViewController.m
//  Banner_demo
//
//  Created by chenshenyi on 16/3/11.
//  Copyright © 2016年 chenshenyi. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<BannerViewDelegate>
{
    
}
@property (nonatomic, strong)NSMutableArray *testArray;
@property (nonatomic, strong)BannerView *bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}


- (NSMutableArray *)testArray
{
    if (!_testArray) {
        _testArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 4; i ++) {
            [_testArray addObject:[NSString stringWithFormat:@"banner_%d.jpg",i + 1]];
        }
    }
    return _testArray;
}

- (BannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 7.0/16 * kScreenWidth)];
        _bannerView.delegate = self;
        _bannerView.dataArray = self.testArray;
    }
    return _bannerView;
}

- (void)configUI
{
    [self.view addSubview:self.bannerView];
}




@end
