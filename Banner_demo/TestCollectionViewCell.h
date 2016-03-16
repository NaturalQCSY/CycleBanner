//
//  TestCollectionViewCell.h
//  Banner_demo
//
//  Created by chenshenyi on 16/3/11.
//  Copyright © 2016年 chenshenyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
