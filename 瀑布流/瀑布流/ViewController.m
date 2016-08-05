//
//  ViewController.m
//  瀑布流
//
//  Created by LHB on 16/8/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import "ViewController.h"
#import "LHBWaterLayout.h"
#import "LHBShopModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "LHBShopCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LHBWaterLayoutDelegate>
/**所有商品数据*/
@property (nonatomic,strong) NSMutableArray *shopsArray;

@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation ViewController

static NSString * const LHBShopID = @"shop";

- (NSMutableArray *)shopsArray
{
    if (!_shopsArray) {
        _shopsArray = [NSMutableArray array];
    }
    return _shopsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    
    [self setupRefresh];
    
    
}

- (void)setupLayout
{
    //创建布局
    LHBWaterLayout *layout = [[LHBWaterLayout alloc] init];
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.delegate = self;
    
    //创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource =self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
//    collectionView.header = [MJRefreshNormalHeader];
    
    [self.view addSubview:collectionView];
    
    //注册
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LHBShopCell class]) bundle:nil] forCellWithReuseIdentifier:LHBShopID];
    //注册系统
//    [collectionView registerClass:[LHBShopCell class] forCellWithReuseIdentifier:LHBShopID];
    
    
    self.collectionView = collectionView;
}
- (void)setupRefresh
{
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}
- (void)loadNewShops
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [LHBShopModel objectArrayWithFilename:@"1.plist"];
        [self.shopsArray removeAllObjects];
        [self.shopsArray addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
    });
    
   
}
- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [LHBShopModel objectArrayWithFilename:@"1.plist"];
        [self.shopsArray addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
    });
}

#pragma mark - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.footer.hidden = self.shopsArray.count==0;
    return self.shopsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHBShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LHBShopID forIndexPath:indexPath];
    cell.shopModel = self.shopsArray[indexPath.item ];
    
    return cell;
}

- (CGFloat)waterflowLayout:(LHBWaterLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    LHBShopModel *model = self.shopsArray[index];
    return itemWidth * model.h / model.w;
}


- (CGFloat)rowMarginInWaterflowLayout:(LHBWaterLayout *)waterflowLayout
{
    return 10;
}

- (CGFloat)columnCountInWaterflowLayout:(LHBWaterLayout *)waterflowLayout
{
    if (self.shopsArray.count <= 50) {
        return 2;
    }return 3;
    
}



- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(LHBWaterLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(20, 10, 10, 10);
}
@end
