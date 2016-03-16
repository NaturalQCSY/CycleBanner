//
//  CircleLineLayout.m
//  Banner_demo
//
//  Created by chenshenyi on 16/3/11.
//  Copyright © 2016年 chenshenyi. All rights reserved.
//

#import "CircleLineLayout.h"

@implementation CircleLineLayout


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

/**
 *  一些准备工作最好放在这里
 */
- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width , self.collectionView.frame.size.height);
    self.minimumLineSpacing = 0;
    //设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}


@end
