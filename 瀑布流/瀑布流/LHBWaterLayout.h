//
//  LHBWaterLayout.h
//  瀑布流
//
//  Created by LHB on 16/8/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHBWaterLayout;

@protocol LHBWaterLayoutDelegate <NSObject>

@required

/**必须实现，返回item的高度*/
- (CGFloat)waterflowLayout:(LHBWaterLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional

/**多少列*/
- (CGFloat)columnCountInWaterflowLayout:(LHBWaterLayout*)waterflowLayout;
/**列间距*/
- (CGFloat)columnMarginInWaterflowLayout:(LHBWaterLayout*)waterflowLayout;
/**行间距*/
- (CGFloat)rowMarginInWaterflowLayout:(LHBWaterLayout*)waterflowLayout;
/**item上下左右可调间距*/
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(LHBWaterLayout*)waterflowLayout;


@end

@interface LHBWaterLayout : UICollectionViewLayout

@property (nonatomic,weak) id <LHBWaterLayoutDelegate> delegate;


@end
