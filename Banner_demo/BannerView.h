//
//  BannerView.h
//  Banner_demo
//
//  Created by chenshenyi on 16/3/17.
//  Copyright © 2016年 chenshenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BannerViewDelegate <NSObject>

@end
@interface BannerView : UIView
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, weak)id <BannerViewDelegate>delegate;
@end
