//
//  AdvertismentView.m
//  Abe UI
//
//  Created by topfuture on 2017/10/23.
//  Copyright © 2017年 abe_liu. All rights reserved.
//

#import "AdvertismentView.h"
#import "AdvertismentCell.h"
//#import "UIViewExt.h"
#import <UIImageView+WebCache.h>
#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface AdvertismentView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSArray *imageUrlArray;
@property(nonatomic,assign)UIPageControlShowStyle style;
@property(nonatomic,strong)UICollectionView *mainView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,assign)NSInteger     totalCount;
@end
static AdvertismentView *advertismentView;
static NSString *reuse=@"REUSE";
@implementation AdvertismentView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout=flowLayout;
        _flowLayout.itemSize=self.frame.size;
        UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [mainView registerClass:[AdvertismentCell class] forCellWithReuseIdentifier:reuse];
        mainView.backgroundColor = [UIColor clearColor];
        mainView.pagingEnabled = YES;
        mainView.showsHorizontalScrollIndicator = NO;
        mainView.showsVerticalScrollIndicator = NO;
        mainView.dataSource = self;
        mainView.delegate = self;
        mainView.scrollsToTop = NO;
        _mainView=mainView;
        [self addSubview:mainView];
    }
    return self;
}
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer=nil;
    }else{
        [self setupTimer];
    }
}
-(void)dealloc{
    _mainView.delegate=nil;
    _mainView.dataSource=nil;
}
-(void)setupTimer{
    if (self.imageUrlArray.count>=2) {
        // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
        [self.timer invalidate];
        self.timer=nil;
        self.timer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(animationMoveImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (int)currentIndex
{
//    if (_mainView.width == 0 || _mainView.height == 0) {
//        return 0;
//    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

-(void)animationMoveImage{
    if (self.imageUrlArray.count==0) {
        return;
    }
    int currentIndex=[self currentIndex];
    int targetIndex=currentIndex+1;
    [self scrollToIndex:targetIndex];
    
}
- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= self.totalCount) {
        NSLog(@"targetIndex%d",targetIndex);
        //从第多少个重新开始
            targetIndex =_totalCount*0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
+(id)adCollectionViewFrame:(CGRect)frame modelArray:(NSArray *)modelArray pageControlShowStyle:(UIPageControlShowStyle)pageControlShowStyle{
    if (advertismentView!=nil) {
        return advertismentView;
    }
    advertismentView=[[AdvertismentView alloc]initWithFrame:frame];
    advertismentView.imageUrlArray=modelArray;
    advertismentView.style=pageControlShowStyle;
    return advertismentView;
    
}
-(void)setStyle:(UIPageControlShowStyle)style{
    
    if (style==UIPageControlShowStyleNone||self.imageUrlArray.count<=1) {
        return;
    }
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = self.imageUrlArray.count;

    
    if (style == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(10, HIGHT+CGRectGetWidth(self.frame) - 20, 20*_pageControl.numberOfPages, 20);
    }
    else if (style == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, HIGHT+CGRectGetHeight(self.frame) - 10);
    }
    else
    {
        _pageControl.frame = CGRectMake( CGRectGetWidth(self.frame  ) - 22*_pageControl.numberOfPages,self.frame.size.height - 20, 20*_pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
    
}
-(void)setImageUrlArray:(NSArray *)imageUrlArray{
    [self.timer invalidate];
    self.timer=nil;
    _imageUrlArray=imageUrlArray;
    _totalCount=self.imageUrlArray.count*100;
    if (imageUrlArray.count>1) {
        self.mainView.scrollEnabled=YES;
    }
    [self.mainView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld",_totalCount);
    return _totalCount;
    
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AdvertismentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    
    int itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    //使用网络图片
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArray[itemIndex]] placeholderImage:[UIImage imageNamed:@"guide1"]];
    //使用本地图片
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageUrlArray[itemIndex]]]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickBlock) {
        int index=[self pageControlIndexWithCurrentCellIndex:indexPath.row];
        self.clickBlock(index);
    }
}
#pragma mark scrollviewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.timer) {
        [self.timer invalidate];
        self.timer=nil;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setupTimer];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int inedx=[self currentIndex];
    int indexOnPageControl=[self pageControlIndexWithCurrentCellIndex:inedx];
    self.pageControl.currentPage=indexOnPageControl;
}



- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imageUrlArray.count;
}



@end
