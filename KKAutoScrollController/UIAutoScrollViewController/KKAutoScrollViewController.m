//
//  KKAutoScrollViewController.m
//  TSAutoScroll
//
//  Created by MR.KING on 16/3/27.
//  Copyright © 2016年 EBJ. All rights reserved.
//

#import "KKAutoScrollViewController.h"
#import "KKAutoPageControl.h"
#import "UIImageView+WebCache.h"
#import "KKAutoCollectionViewCell.h"

@interface KKAutoScrollViewController()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGRect _frame;
}
@property(nonatomic,strong)KKAutoPageControl * pageControl;

@property (nonatomic, strong) NSTimer *myTimer; /**<  定时器   **/

@property(nonatomic,assign)NSInteger totalNumber;

@property(nonatomic,assign)NSInteger currentPage;

@property(nonatomic,strong)UICollectionView * autoScrolloView;

@end



@implementation KKAutoScrollViewController

#define NumOfCopy 5000

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self invalidateTimer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _frame = frame;
        [self setUI];
        self.animationDurtion = 2.0f;
        self.pageControlNormalColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0  blue:210.0/255.0  alpha:0.8];
        self.pageControlSeletedColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEnterForeGround:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}


-(void)didEnterForeGround:(NSNotification*)notifi{
    [self setMyTimerWithTimerInterVal:self.animationDurtion];
}

-(void)didEnterBackGround:(NSNotification*)notifi{
    [self invalidateTimer];
}


-(void)setUI{
    self.view = [[UIView alloc]initWithFrame:_frame];
    
    [self.view addSubview:self.autoScrolloView];
    
    [self initPageControl];
    [self.view addSubview:self.pageControl];
}

-(UICollectionView *)autoScrolloView{
    if (!_autoScrolloView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.estimatedItemSize = CGSizeMake([self width], [self height]);
        layout.headerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _autoScrolloView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [self width], [self height] ) collectionViewLayout:layout];
        [_autoScrolloView registerNib:[UINib nibWithNibName:@"KKAutoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
        _autoScrolloView.showsHorizontalScrollIndicator = NO;
        _autoScrolloView.pagingEnabled = YES;
        _autoScrolloView.delegate = self;
        _autoScrolloView.dataSource = self;
        _autoScrolloView.backgroundColor = [UIColor whiteColor];
        [_autoScrolloView reloadData];
    }
    return _autoScrolloView;
}




#pragma mark - timer's action
/**
 *  the action for myTimer
 */
-(void)scrollAction{
    if ([self.autoScrolloView numberOfItemsInSection:0] == 0) {
        return;
    }
    NSIndexPath * currentIndex = [[self.autoScrolloView indexPathsForVisibleItems]lastObject] ;
    if (!currentIndex) {
        return;
    }
    NSIndexPath * nextIndex = [NSIndexPath indexPathForRow:currentIndex.row + 1 inSection:0];
    [self.autoScrolloView scrollToItemAtIndexPath:nextIndex atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self upatePageControlCurrentPageTo:nextIndex.row % self.imageUrl.count];
    /**
     *  如果下一个将要显示的我最后10组。则自动跳到最开始的 
     *  防止循环到末尾
     */
    if (nextIndex.row  > (NumOfCopy - 10) * self.imageUrl.count) {
        // 计算开始的 20组的偏移量
        CGFloat X = nextIndex.row %self.imageUrl.count * [self width]
        +
        20 * self.imageUrl.count * [self width];
        
        self.autoScrolloView.contentOffset = CGPointMake(X, 0);
    }
}


#pragma mark - set proty
-(void)setPageControlNormalColor:(UIColor *)pageControlNormalColor{
    _pageControlNormalColor = pageControlNormalColor;
    self.pageControl.pageIndicatorTintColor = _pageControlNormalColor;
}

-(void)setPageControlSeletedColor:(UIColor *)pageControlSeletedColor{
    _pageControlSeletedColor = pageControlSeletedColor;
    self.pageControl.currentPageIndicatorTintColor = pageControlSeletedColor;
}

/**
 *  when the animatinDrtion was set, should resert timer
 *
 *  @param animationDurtion
 */
-(void)setAnimationDurtion:(CGFloat)animationDurtion{
    _animationDurtion = animationDurtion;
    [self invalidateTimer];
    if (_animationDurtion <= 0.5) {
        
    }else{
        [self setMyTimerWithTimerInterVal:_animationDurtion];
    }
}



#pragma mark - initPageControl
- (void)initPageControl {
    _pageControl = [[KKAutoPageControl alloc]init];
    _pageControl.currentPageIndicatorTintColor = self.pageControlNormalColor;
    _pageControl.pageIndicatorTintColor = self.pageControlSeletedColor;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.center = CGPointMake([self width] / 2.0, [self height] - 10);
}

-(void)setImageUrl:(NSArray *)imageUrl{
    _imageUrl = imageUrl;
    self.totalNumber = imageUrl.count;
    if (imageUrl.count <= 1) {
        self.autoScrolloView.scrollEnabled = NO;
        [self invalidateTimer];
    }else{
        self.autoScrolloView.scrollEnabled = YES;
        [self setMyTimerWithTimerInterVal:self.animationDurtion];
    }
    [self.autoScrolloView reloadData];
    [self performSelector:@selector(scrollTo20Group) withObject:nil afterDelay:0.4];
}

-(void)scrollTo20Group{
    NSIndexPath * index = [NSIndexPath indexPathForRow:20 * self.imageUrl.count inSection:0];
    if ([self.autoScrolloView cellForItemAtIndexPath:index]) {
        [self.autoScrolloView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
}



-(void)setTotalNumber:(NSInteger)totalNumber{
    _totalNumber= totalNumber;
    self.pageControl.numberOfPages = totalNumber;
}


-(void)upatePageControlCurrentPageTo:(NSInteger)index{
    self.pageControl.currentPage = index;
}



#pragma mark - collectionView  delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return NumOfCopy * self.imageUrl.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKAutoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [cell showDataWithImageUrl:self.imageUrl[indexPath.row% self.imageUrl.count] placeHolderImage:self.placeHolderImage title:(indexPath.row%self.imageUrl.count <= self.titles.count - 1)?self.titles[indexPath.row %self.imageUrl.count]:@""];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(autoScrollView:didClickAtItem:)]) {
            [self.delegate autoScrollView:self didClickAtItem:indexPath.row %self.imageUrl.count];
        }
    }
}

/**
 *  监测到有拖动的动作时，暂停定时器。
 *
 *  @param scrollView 当前scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.imageUrl.count > 1) {
        [self pauseTimer];
    }
}



-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.animationDurtion > 0.5 && self.totalNumber > 1) {
        [self resumeTimeAfter:self.animationDurtion];
    }
    // 目标停止的 位置
    CGPoint point = *targetContentOffset;
    
    // 目标位置
    NSInteger targetPage = point.x / [self width];
    
    // 设置page
    [self upatePageControlCurrentPageTo:targetPage % self.imageUrl.count];
}





#pragma mark - SetupTimer

-(void)pauseTimer{
    if (self.myTimer) {
        self.myTimer.fireDate = [NSDate distantFuture];
    }
}

-(void)resumeTimer{
    if (self.myTimer) {
        self.myTimer.fireDate = [NSDate distantPast];
    }
}

-(void)resumeTimeAfter:(NSTimeInterval)timeInterVal{
    if (self.myTimer) {
        self.myTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterVal];
    }
}

-(void)setMyTimerWithTimerInterVal:(NSTimeInterval)timerInterVal{
    if (timerInterVal < 0.5) {
        if (self.myTimer) {
            [self invalidateTimer];
        }
        return;
    }
    if (_myTimer) {
        [self invalidateTimer];
    }
    _myTimer = [NSTimer timerWithTimeInterval:timerInterVal target:self selector:@selector(scrollAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];

}

-(void)invalidateTimer{
    [_myTimer invalidate];
    _myTimer = nil;
}

-(CGFloat)width{
    return _frame.size.width;
}

-(CGFloat)height{
    return _frame.size.height;
}



@end


