//
//  ViewController.m
//  Banner_demo
//
//  Created by chenshenyi on 16/3/11.
//  Copyright © 2016年 chenshenyi. All rights reserved.
//

#import "ViewController.h"
#import "TestCollectionViewCell.h"
#import "CircleLineLayout.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    NSTimer *_timer;
}
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSMutableArray *testArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configData];
    [self createCollectionView];
    [self addNSTimer];
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(self.view.center.x, 200 - 30);
        //    [_pageController setBounds:CGRectMake(0, 0, 80, 0)];
        _pageControl.numberOfPages = self.testArray.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

- (NSMutableArray *)testArray
{
    if (!_testArray) {
        _testArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 4; i ++) {
            [_testArray addObject:[NSString stringWithFormat:@"banner_%d",i + 1]];
        }
    }
    return _testArray;
}

- (void)configData
{
    
    
}
#define kReuseID @"ReuseCell"
- (void)createCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) collectionViewLayout:[[CircleLineLayout alloc] init]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kReuseID];
    [self.view addSubview:_collectionView];
    [self.view addSubview:self.pageControl];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor purpleColor];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(50, 250, 100, 50);
    [addBtn addTarget:self action:@selector(addDataCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor purpleColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(kScreenWidth - 150, 250, 100, 50);
    [deleteBtn addTarget:self action:@selector(deleteDataCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [self.view addSubview:deleteBtn];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view setValue:self forKey:@"delegate"];
        }
    }
}



- (void)addDataCount:(UIButton *)btn
{
    [self.testArray insertObject:@"banner_2" atIndex:1];
    self.pageControl.numberOfPages = self.testArray.count;
//    NSIndexPath *currentIndexPath=[[_collectionView indexPathsForVisibleItems] lastObject];
//    NSInteger nextItem=currentIndexPath.item;
//    NSInteger nextSection=currentIndexPath.section;
//    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
//    self.pageControl.currentPage = nextIndexPath.row + 1;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [_collectionView reloadData];
//    [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    self.pageControl.currentPage
}

- (void)deleteDataCount:(UIButton *)btn
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offSetX = scrollView.contentOffset.x;
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"将要拖动");
//    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"停止拖动");
//    [_timer setFireDate:[NSDate date]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"开始滑动");
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"将要展示%@",indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"结束展示%@",indexPath);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.testArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseID forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor orangeColor];
    cell.testLabel.text = [NSString stringWithFormat:@"当前是第%ld个cell",(long)indexPath.row + 1];
    cell.bgView.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1];
    cell.bgIv.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_testArray[indexPath.row] ofType:@"png"]];
    return cell;
}


-(void)addNSTimer
{
    //    NSTimer timerWithTimeInterval:<#(NSTimeInterval)#> target:<#(id)#> selector:<#(SEL)#> userInfo:<#(id)#> repeats:<#(BOOL)#>
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)nextPage
{
    //    NSLog(@"%@",[self.collectinView indexPathsForVisibleItems]);
    //1）获取当前正在展示的位置
    NSIndexPath *currentIndexPath=[[_collectionView indexPathsForVisibleItems] lastObject];
    
    
    //2）计算出下一个需要展示的位置
    NSInteger nextItem=currentIndexPath.item+1;
    NSInteger nextSection=currentIndexPath.section;
    if (nextItem ==self.testArray.count) {
        nextItem = 0;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    //slow at beginning and end
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    @"fade",@"push",@"moveIn",@"reveal",@"cube",@"oglFlip",@"suckEffect",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"
    animation.type = @"push";
    
    //
    [animation setSubtype:kCATransitionFromRight];
    
    [_collectionView.layer addAnimation:animation forKey:@"animation"];
    
    //3）通过动画滚动到下一个位置
    [_collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    _pageControl.currentPage = nextIndexPath.row;
}

@end
