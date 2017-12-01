
### 滚动广告图实现解析
- 讲解：首先滚动图内部 是一个 CollectionView
通过setImageArray 和setStyle 来分别实现 数据增加和pageContrl 的实例化

**本质是创建多个contentviewCell**

```
//为数据填充新的值
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
```
**设置pageContrl**

```
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
```

**每一个cell 的显示**

```
//cell 显示的是传递进来的数组的 indexpath.row
AdvertismentCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
[cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"guide1"]];
return cell;

```

**滚动代理的实现方法**
```
#pragma mark scrollviewDelegate
//当contentview 开始手动拖拽的时候停止计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
if (self.timer) {
[self.timer invalidate];
self.timer=nil;
}
}
//当scrollview 结束拖拽的时候开启计时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setupTimer];
}
//在滚动的时候动态完成pageContrl 的显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int inedx=[self currentIndex];
    int indexOnPageControl=[self pageControlIndexWithCurrentCellIndex:inedx];
    self.pageControl.currentPage=indexOnPageControl;
}



- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imageUrlArray.count;
}

```



