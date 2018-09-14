# LMAutoCycleScrollView

###实现图片自动轮播的效果

####一、实现功能主要逻辑
* 1. 在需要展示图片的首尾添加两张图片， 比如四张图 （4）|（1）（2）（3）（4）|（1）左右两边的4和1是加上去的，实际是展示了6张图；
* 2. 在图片滚动到边界的时候进行跳转，例如图片滚动到边界（1）图的时候，跳转到显示图片（1）的位置，展示的依然是同样的图，但是位置已经不一样了，造成一种轮播的假象，相应的pageControl的currentPage跟着变换；
* 3. 关于自己轮播的效果，是添加一个定时器，需要注意的是在用户手动拖拽的时候需要关闭定时器，以免当用户停止拖拽的时候一下子轮播跳转好几张图片；




####二、实现功能主要代码
1->设置图片

```
/**
 设置轮播图的主要逻辑
 @param count 需要展示的图片数目
 */
-(void)setImageCount:(NSUInteger)count{
    //首尾各加一张图片，所以图片个数加2
    count = count + 2;
    //for循环摆图，首尾特别设置一下，其他依次排图
    for (int i = 0; i < count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * Width, 0, Width, Height)];
        if (i == 0) {
            imageView.image = [UIImage imageNamed:@"image4"];
        }else if (i == count -1){
            imageView.image = [UIImage imageNamed:@"image1"];
        }else
        {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]];
            
        }
        [self.scrollView addSubview:imageView];
    }
    //赋值给实例变量count
    _count = count;
    //自定义pageControl1的page数目
    self.pageControl1.numberOfPages = _count-2;
    //设置scrollView的contentSize，只有设置了，scrollView才能够滚动
    self.scrollView.contentSize = CGSizeMake(Width*_count, Height);
    //设置scrollView的当前显示位置
    [self.scrollView setContentOffset:CGPointMake(Width, 0)];
    
}
```
2->设置边界跳转，形成循环播放的假象

```
/**
 1. 在边界处进行判断，实现scrollview和pagecontrol的跳转
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /* 比如四张图 （4）|（1）（2）（3）（4）|（1）左右两边的4和1是加上去的
    1->当滚动到最后一个图片（1）的时候代表是向右滚动的，并且已经滚动到（1）了，这时候将scrollView的contentOffset.x设置成中间四张展示的图片中1的offset，就会造成视觉上循环的假象；
    2->同上理，当滚动到左边第一章图片（4）的位置的时候，可以判断是向左滚动的，因为如果向右滚动按照上面的逻辑是滚动够不到者张图片的。这时将scrollView的contentOffset.x设置成展示图片中（4）的位置就可以了；
    3->pageControl的位置同样跟着转换；
     */
    if (scrollView.contentOffset.x == Width * (_count - 1)) {
        [self.scrollView setContentOffset:CGPointMake(Width, 0)];
    }else if (scrollView.contentOffset.x == 0)
    {
        CGFloat x = self.scrollView.bounds.size.width * (_count-2);
        [self.scrollView setContentOffset:CGPointMake(x, 0)];
    }
    //计算pageControl当前对应着scrollView的所在位置应该所在页数
    _page = (scrollView.contentOffset.x - Width)/Width;
    //调整pageControl的页数
    self.pageControl.currentPage = _page;
    self.pageControl1.currentPage = _page;
    
}
```
3->定时器的处理，注意在拖拽的时候停止定时器

```
-(void)changeCurrentPage{
    
    self.pageControl.currentPage = _page;
    self.pageControl1.currentPage = _page;
    //这里pageControl的页数和scrollView有差异，导致会出现随着时间轮播
    [self.scrollView setContentOffset:CGPointMake(Width * (self.pageControl1.currentPage+2), 0) animated:YES];
    _page ++;
}
```







