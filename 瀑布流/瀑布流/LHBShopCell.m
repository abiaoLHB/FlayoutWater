//
//  LHBShopCell.m
//  瀑布流
//
//  Created by LHB on 16/8/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import "LHBShopCell.h"
#import "LHBShopModel.h"
#import "UIImageView+WebCache.h"

@interface LHBShopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation LHBShopCell

- (void)setShopModel:(LHBShopModel *)shopModel
{
    _shopModel = shopModel;
    
    NSString *imageUrl = shopModel.img;
    NSLog(@"%@",imageUrl);
    
//    [self.shopImaeView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.shopImageView.image = [UIImage imageNamed:@"test.jpg"];
//    self.shopImaeView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
    
    self.priceLabel.text = shopModel.price;
}


@end
