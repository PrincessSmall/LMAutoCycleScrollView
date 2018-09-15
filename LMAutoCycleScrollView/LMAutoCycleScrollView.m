//
//  LMAutoCycleScrollView.m
//  LMAutoCycleScrollView
//
//  Created by 李敏 on 2018/8/16.
//  Copyright © 2018年 李敏. All rights reserved.
//

#import "LMAutoCycleScrollView.h"
#import "LMPageControl.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@interface LMAutoCycleScrollView()<UIScrollViewDelegate>{
    NSInteger _count;
    NSInteger _page;//记录pageControl的当前页数
}

@property (nonatomic ,strong)UIScrollView * scrollView;
/*计时器*/
@property (nonatomic ,strong)NSTimer * timer;
/*系统pageControl*/
@property (nonatomic ,strong)UIPageControl * pageControl;
/*自定义pageControl*/
@property (nonatomic ,strong)LMPageControl * pageControl1;


@end

@implementation LMAutoCycleScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.pageControl1];
        
       
    }
    return self;
}


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
        imageView.contentMode = UIViewContentModeScaleAspectFit;//等比例填充图片，按照长或者宽有一边抵达边界为止，不会变形，可能会填不满viewqu yu
        [self.scrollView addSubview:imageView];
    }
    //赋值给实例变量count
    _count = count;
    //设置pageControl的page数目，为了和下面自定义pageControl做对比的
    self.pageControl.numberOfPages = _count-2;
    //pageControl的当前页
    self.pageControl.currentPage = 0;
    //自定义pageControl1的page数目
    self.pageControl1.numberOfPages = _count-2;
    //设置scrollView的contentSize，只有设置了，scrollView才能够滚动
    self.scrollView.contentSize = CGSizeMake(Width*_count, Height);
    //设置scrollView的当前显示位置
    [self.scrollView setContentOffset:CGPointMake(Width, 0)];
    
}


#pragma  mark --lazy

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
        //是否能够翻页
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        //是否需要弹簧效果，默认是YES
        _scrollView.bounces = NO;
        //是否显示水平滚动条，默认是YES
        _scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(Width/2.0-50, Height+20, 100, 10)];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(LMPageControl *)pageControl1{
    if (!_pageControl1) {
        _pageControl1 = [[LMPageControl alloc]initWithFrame:CGRectMake(Width/2.0-50, Height-20, 100, 10)];
        //使用KVC修改pageControl的滚动显示条
        [_pageControl1 setValue:[UIImage imageNamed:@"11111"] forKeyPath:@"pageImage"];
        [_pageControl1 setValue:[UIImage imageNamed:@"22222"] forKeyPath:@"currentPageImage"];
        _pageControl1.currentPage = 0;
        
    }
    return _pageControl1;
}


#pragma mark --UIScrollViewDelegate
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

//scrollView开始拖拽的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止即使器，以防用户在拖拽时计时器依然在继续，在用户停止的时候会导致图片连续轮播几张
    [self endNStimer];
}

//scrollView停止减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //开始计时
    [self startNSTimer];
}


#pragma mark --NSTimer

-(void)startNSTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(changeCurrentPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
-(void)endNStimer{
    
    [self.timer invalidate];
    self.timer = nil;
}

//改变pageControlPage
-(void)changeCurrentPage{
    
    self.pageControl.currentPage = _page;
    self.pageControl1.currentPage = _page;
    //这里pageControl的页数和scrollView有差异，导致会出现随着时间轮播
    [self.scrollView setContentOffset:CGPointMake(Width * (self.pageControl1.currentPage+2), 0) animated:YES];
    _page ++;
}


 





@end
