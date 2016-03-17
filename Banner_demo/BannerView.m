//
//  BannerView.m
//  Banner_demo
//
//  Created by chenshenyi on 16/3/17.
//  Copyright © 2016年 chenshenyi. All rights reserved.
//

#import "BannerView.h"
#import "CircleLineLayout.h"
#import "TestCollectionViewCell.h"

#define kAdReuseID @"AdReuseCell"
@interface BannerView () <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSMutableArray *_finalArray;
}
@property (nonatomic, strong)UICollectionView *bannerCollectionView;
@property (nonatomic, strong)UIPageControl *pageControl;

@end

@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self addSubviewWithFrame:frame];
    }
    return self;
}

- (void)initData
{
    _finalArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)addSubviewWithFrame:(CGRect)frame
{
    [self.bannerCollectionView setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [self addSubview:self.bannerCollectionView];
    self.pageControl.center = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetHeight(frame) - 10);
    [self addSubview:self.pageControl];
    [self addNSTimer];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view setValue:self forKey:@"delegate"];
        }
    }
}


- (UICollectionView *)bannerCollectionView
{
    if (!_bannerCollectionView) {
        _bannerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:[[CircleLineLayout alloc] init]];
        _bannerCollectionView.delegate = self;
        _bannerCollectionView.dataSource = self;
        _bannerCollectionView.backgroundColor = [UIColor whiteColor];
        _bannerCollectionView.pagingEnabled = YES;
        _bannerCollectionView.showsHorizontalScrollIndicator = NO;
        [_bannerCollectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kAdReuseID];
    }
    return _bannerCollectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        //    [_pageController setBounds:CGRectMake(0, 0, 80, 0)];
        _pageControl.numberOfPages = self.dataArray.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = nil;
        [_finalArray removeAllObjects];
        _dataArray = dataArray;
        if (_dataArray.count == 1) {
            self.bannerCollectionView.scrollEnabled = NO;
            [_finalArray insertObject:_dataArray[0] atIndex:0];
        } else {
            self.bannerCollectionView.scrollEnabled = YES;
            for (int i = 0; i < _dataArray.count; i ++) {
                [_finalArray insertObject:_dataArray[i] atIndex:i];
            }
            [_finalArray insertObject:_dataArray[_dataArray.count - 1] atIndex:0];
            [_finalArray insertObject:_dataArray[0] atIndex:_dataArray.count + 1];
        }
        self.pageControl.numberOfPages = self.dataArray.count;
        [self.bannerCollectionView reloadData];
        self.pageControl.currentPage = 0;
        [self.bannerCollectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
    }
}

#pragma mark - ScrollView Deleagte

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"开始滚动");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    //    NSLog(@"偏移量x:%f",offSetX);
    
    if (offSetX == 0) {
        self.pageControl.currentPage = self.dataArray.count - 1;
        [self.bannerCollectionView setContentOffset:CGPointMake((self.dataArray.count)*CGRectGetWidth(self.frame), 0)];
    } else if (offSetX == (self.dataArray.count + 1)*CGRectGetWidth(self.frame)) {
        self.pageControl.currentPage = 0;
        [self.bannerCollectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
    } else {
        self.pageControl.currentPage = offSetX/CGRectGetWidth(self.frame) - 1;
    }
}

#pragma mark - 开关定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    NSLog(@"将要拖动");
    //    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"停止拖动");
    //    [_timer setFireDate:[NSDate date]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _finalArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAdReuseID forIndexPath:indexPath];
    cell.bgIv.contentMode = UIViewContentModeScaleToFill;
    cell.bgIv.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_finalArray[indexPath.row] ofType:nil]];
    cell.testLabel.text = @"";
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark 添加定时器
-(void)addNSTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 自动滚动
-(void)nextPage
{
    //    return;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    //slow at beginning and end
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    @"fade",@"push",@"moveIn",@"reveal",@"cube",@"oglFlip",@"suckEffect",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"
    animation.type = @"push";
    
    //
    [animation setSubtype:kCATransitionFromRight];
    
    [self.bannerCollectionView.layer addAnimation:animation forKey:@"animation"];
    
    CGFloat currentOffSetX = self.bannerCollectionView.contentOffset.x;
    if (currentOffSetX == (self.dataArray.count) * CGRectGetWidth(self.frame)) {
        self.pageControl.currentPage = 0;
        [self.bannerCollectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0)];
    } else {
        [self.bannerCollectionView setContentOffset:CGPointMake(currentOffSetX + CGRectGetWidth(self.frame), 0)];
        self.pageControl.currentPage = (currentOffSetX + CGRectGetWidth(self.frame))/CGRectGetWidth(self.frame) - 1;
    }
}

@end
