//
//  LHBWaterLayout.m
//  瀑布流
//
//  Created by LHB on 16/8/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import "LHBWaterLayout.h"


/*********************************************************
 *  继承根布局要实现的四个方法
 *********************************************************/

/**默认列数*/
static const NSInteger LHBDefaultColumnCount = 3;
/**每一列之间的间距*/
static const CGFloat LHBDefaultColumnMargin = 10;
/**每一列之间的间距*/
static const CGFloat LHBDefaultRowMargin = 10;
/**边距间距 结构体*/
static const UIEdgeInsets LHBDefaultUIEdgeInsets = {10,10,10,10};

@interface LHBWaterLayout ()

/**存放所有cell的布局属性*/
@property (nonatomic,strong) NSMutableArray *attrsArray;

/**存放所有列的最大Y值（当前高度）*/
@property (nonatomic,strong) NSMutableArray *columnHeightArray;
/**最大内容高度*/
@property (nonatomic,assign) CGFloat contentHeight;

/**行间距*/
- (CGFloat)rowMargin;
/**列间距*/
- (CGFloat)columnMargin;
/**列数*/
- (NSInteger)columnCount;
/**item上下左右距离*/
- (UIEdgeInsets)edgeInsets;

@end

 
@implementation LHBWaterLayout

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
       return  [self.delegate rowMarginInWaterflowLayout:self];
    }else{
        return LHBDefaultRowMargin;
    }
}
- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }else{
        return LHBDefaultColumnMargin;
    }
}
- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    }else{
        return LHBDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    }else{
        return LHBDefaultUIEdgeInsets;
    }
}


- (NSMutableArray *)columnHeightArray
{
    if (!_columnHeightArray) {
        _columnHeightArray = [NSMutableArray array];
    }
    return _columnHeightArray;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 *  只调用一次(刷新的时候会调用)
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    //清除以前计算的所有高度
    [self.columnHeightArray removeAllObjects];
    
    for (NSInteger i=0; i < self.columnCount; i++) {
        [self.columnHeightArray addObject:@(self.edgeInsets.top)];
    }
    
    
    //清除之前的所有布局属性（防止刷新的时候往数组塞属性，造成数组月来越大）
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    
        for (NSInteger i=0; i<count; i++) {
    
            //创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    
            //获取indexPath位置cell对应的属性
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            
            //这个放到- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath里面调用
//            //创建indexpath位置的属性
//            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    
//            //设置布局属性的frame
//            attr.frame = CGRectMake(arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30));
//    
            //把布局放进数组
            [self.attrsArray addObject:attr];
        }


}
/**
 *  决定cell的排布..继承自根布局，调用非常频繁。苹果的流水布局不会
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%s",__func__);
    
//    写这里也行，就行条用太频繁，一般挪到prepareLayout里面去写
//    //创建一个数组，存放所有cell的布局属性
//    NSMutableArray *array = [NSMutableArray array];
//    
//    //cell总数
//    NSInteger count = [self.collectionView numberOfItemsInSection:0];
//    
//    
//    for (NSInteger i=0; i<count; i++) {
//        
//        //创建位置
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        
//        //创建indexpath位置的属性
//        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//        
//        //设置布局属性的frame
//        attr.frame = CGRectMake(arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30));
//        
//        //把布局放进数组
//        [array addObject:attr];
//    }
//    return array;
    
    
//    return 的是self.attrArray
    return self.attrsArray;
}

/**
 *  继承根布局要实现的方法
 *  返回indexPath位置cell对应的布局属性...重点在算，这是核心方法
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建indexpath位置的属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    //设置布局属性的frame
    /* 第一种方法 ，block遍历
        //找出高度最短（最小）的那一列.destColumn变量是目标列，最小的那列
       __block NSInteger destColumn = 0;
        //最小的高度,初始化最大，才能找到比他小的，再赋值
        __block CGFloat minColumnHeight = MAXFLOAT;
        //怎么找？便利存放高度的数组。这里用block遍历
        //self.columnHeightArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {}
        //数组里面都是对象
        [self.columnHeightArray enumerateObjectsUsingBlock:^(NSNumber * columnNuber, NSUInteger idx, BOOL *stop) {
            CGFloat columnHeight = columnNuber.doubleValue;
            if (minColumnHeight > columnHeight) {
                minColumnHeight = columnHeight;
                //目标列
                destColumn = idx;
            }
            
        }];
    */
    /*第二种遍历方法
    //找出高度最短（最小）的那一列.destColumn变量是目标列，最小的那列
    NSInteger destColumn = 0;
    //最小的高度,初始化最大，才能找到比他小的，再赋值
    CGFloat minColumnHeight = MAXFLOAT;
    for (NSInteger i =0 ; i<self.columnHeightArray.count; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.columnHeightArray[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            //找到最小高度
            minColumnHeight = columnHeight;
            //记录列号
            destColumn = i;
        }
        
    }
    */
    
    
    //宽高
    CGFloat width = (collectionViewW - self.edgeInsets.left - self.edgeInsets .right - (self.columnCount - 1) * self.columnMargin)/self.columnCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:width];

    //优化第二种遍历方法，找一层遍历
    //找出高度最短（最小）的那一列.destColumn变量是目标列，最小的那列
    NSInteger destColumn = 0;
    //最小的高度,假设第一列最小
    CGFloat minColumnHeight = [self.columnHeightArray[0] doubleValue];
    //从第1列开始遍历
    for (NSInteger i = 1 ; i<self.columnCount; i++) {
        //取出第i列的高度
        CGFloat columnHeight = [self.columnHeightArray[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            //找到最小高度
            minColumnHeight = columnHeight;
            //记录列号
            destColumn = i;
        }
        
    }

    CGFloat x = self.edgeInsets.left + destColumn * (width + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attr.frame = CGRectMake(x,y,width,height);
    
    //更新最短那列的高度
    self.columnHeightArray[destColumn] = @(CGRectGetMaxY(attr.frame));

    //记录内容的高度
    CGFloat columnHeight = [self.columnHeightArray[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attr;
}

- (CGSize)collectionViewContentSize
{
//    还是这样遍历找最高的靠谱
//    //最大高度
//    CGFloat maxColumnHeight = [self.columnHeightArray[0] doubleValue];
//    //从第1列开始遍历
//    for (NSInteger i = 1 ; i<self.columnHeightArray.count; i++) {
//        //取出第i列的高度
//        CGFloat columnHeight = [self.columnHeightArray[i] doubleValue];
//        if (maxColumnHeight < columnHeight) {
//            maxColumnHeight = columnHeight;
//        }
//        
//    }
//    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
    return CGSizeMake(0, self.contentHeight+ self.edgeInsets.bottom);
}

@end
