

#import "CXImageBrowserView.h"
#import "PageViewControllerData.h"
#import "ImageScrollView.h"

@interface CXImageBrowserView () <UIScrollViewDelegate>{
    __weak UILabel *index_lab;
    __weak UIButton *right_btn;
    
    UIScrollView *scrollView_;
//    NSUInteger startWithIndex_;
    NSInteger currentIndex_;
    NSInteger photoCount_;
    NSMutableArray *photoViews_;
}

//@property (nonatomic, strong)NSMutableArray *mSourceAssets;
@property (nonatomic, strong) NSMutableArray *mSelectAssets;

@property NSUInteger startIndex;

@end

@interface CXImageBrowserView (KTPrivate)

- (void)setCurrentIndex:(NSInteger)newIndex;
//- (void)toggleChrome:(BOOL)hide;
//- (void)startChromeDisplayTimer;
//- (void)cancelChromeDisplayTimer;
//- (void)hideChrome;
//- (void)showChrome;
//- (void)swapCurrentAndNextPhotos;
- (void)nextPhoto;
- (void)previousPhoto;
//- (void)toggleNavButtons;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (void)loadPhoto:(NSInteger)index;
- (void)unloadPhoto:(NSInteger)index;
//- (void)trashPhoto;
//- (void)exportPhoto;

@end

@implementation CXImageBrowserView


+ (CXImageBrowserView *)imageBrowserSource:(NSArray *)source select:(NSArray *)select startIndex:(NSInteger)startIndex{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    PageViewControllerData *instance = [PageViewControllerData sharedInstance];
    instance.photoAssets   = source;
    
//    instance.photoSelected = arrSelected;
    
    // start viewing the image at the appropriate cell index
 /*   NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin], forKey: UIPageViewControllerOptionSpineLocationKey,
                            [NSNumber numberWithFloat:12],
                            UIPageViewControllerOptionInterPageSpacingKey,nil];*/
//    NSDictionary *options = @{[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]: UIPageViewControllerOptionSpineLocationKey,UIPageViewControllerOptionInterPageSpacingKey:[NSNumber numberWithFloat:10]};
//    CXBrowserView *pageViewController = [[CXBrowserView alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    CXImageBrowserView *pageViewController = [[CXImageBrowserView alloc] initWithFrame:[[UIScreen mainScreen] bounds] startIndex:startIndex];
    pageViewController.mSelectAssets = (NSMutableArray *)select;
    return pageViewController;
}

- (id)initWithFrame:(CGRect)frame startIndex:(NSUInteger)index{

    if (self = [super initWithFrame:frame]) {
        _startIndex = index;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 44)];
        [self addSubview:view];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        
        UIImage *backImage = [UIImage imageNamed:@"back.png"];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:backBtn];
        backBtn.frame = CGRectMake(20, 30, 25, 25);
        [backBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:backImage forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        PageViewControllerData *instance = [PageViewControllerData sharedInstance];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 20-2, 100, kHeight_TITLE)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%u/%u",(unsigned int)self.startIndex+1, (unsigned int)instance.photoAssets.count];
        index_lab = label;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-kBottomBarHeight,frame.size.width, kBottomBarHeight)];
//        [self addSubview:view];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.7;
        
            
        [self loadScrollView];
        [self scrollViewDidLoad];
    }
    return self;
}

#pragma mark - button click 返回按钮操作
- (void)leftBtnPressed:(id)sender{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        self.center = CGPointMake(self.center.x+self.frame.size.width, self.center.y) ;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:DONE_BROWSERVIEWDISMISS object:nil];
//    [PageViewControllerData sharedInstance].photoAssets = nil;
//    _mSelectAssets = nil;
}

- (void)loadScrollView
{
    CGRect scrollFrame = [self frameForPagingScrollView];
    UIScrollView *newView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [newView setDelegate:self];

    [newView setBackgroundColor:[UIColor blackColor]];
    [newView setAutoresizesSubviews:YES];
    [newView setPagingEnabled:YES];
    [newView setShowsVerticalScrollIndicator:NO];
    [newView setShowsHorizontalScrollIndicator:NO];
    
    [self addSubview:newView];
    
    scrollView_ = newView;
    [self sendSubviewToBack:newView];
}

- (void)setTitleWithCurrentPhotoIndex
{
    PageViewControllerData *instance = [PageViewControllerData sharedInstance];
    
    index_lab.text = [NSString stringWithFormat:@"%@/%@",@(currentIndex_+1), @(instance.photoAssets.count)];
}

- (void)scrollToIndex:(NSInteger)index
{
    CGRect frame = scrollView_.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [scrollView_ scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
    NSInteger pageCount = photoCount_;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(scrollView_.frame.size.width * pageCount,
                             scrollView_.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [scrollView_ setContentSize:size];
}

- (void)scrollViewDidLoad
{
    PageViewControllerData *instance = [PageViewControllerData sharedInstance];
    photoCount_ = instance.photoAssets.count;
    [self setScrollViewContentSize];
    
    // Setup our photo view cache. We only keep 3 views in
    // memory. NSNull is used as a placeholder for the other
    // elements in the view cache array.
    photoViews_ = [NSMutableArray arrayWithCapacity:photoCount_];
    for (int i=0; i < photoCount_; i++) {
        [photoViews_ addObject:[NSNull null]];
    }
    
    // The first time the view appears, store away the previous controller's values so we can reset on pop.
//    
//    if (!viewDidAppearOnce_) {
//        viewDidAppearOnce_ = YES;
//        statusBarStyle_ = [[UIApplication sharedApplication] statusBarStyle];
//    }
    // Then ensure translucency. Without it, the view will appear below rather than under it.
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    // Set the scroll view's content size, auto-scroll to the stating photo,
    // and setup the other display elements.
    [self setScrollViewContentSize];
    [self setCurrentIndex:_startIndex];
    [self scrollToIndex:_startIndex];
    
    id currentPhotoView = [photoViews_ objectAtIndex:currentIndex_];
    if ([currentPhotoView isKindOfClass:[ImageScrollView class]]) {
        [currentPhotoView showImage];
    }
    
//    [self setTitleWithCurrentPhotoIndex];
//    [self toggleNavButtons];
//    [self startChromeDisplayTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Reset nav bar translucency and status bar style to whatever it was before.
    //[[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle_ animated:YES];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [self cancelChromeDisplayTimer];
//}

- (void)deleteCurrentPhoto
{
    //if (dataSource_) {
        // TODO: Animate the deletion of the current photo.
        NSInteger photoIndexToDelete = currentIndex_;
        [self unloadPhoto:photoIndexToDelete];
            [self unloadPhoto:photoIndexToDelete-1];
            [self unloadPhoto:photoIndexToDelete+1];
        //[dataSource_ deleteImageAtIndex:photoIndexToDelete];
        
        photoCount_ -= 1;
//        if (photoCount_ == 0) {
//            [self showChrome];
//        } else {
            NSInteger nextIndex = photoIndexToDelete;
            if (nextIndex == photoCount_) {
                nextIndex -= 1;
            }
    
            [self setScrollViewContentSize];
            [self setCurrentIndex:nextIndex];
            [self scrollToIndex:nextIndex];

//        }
    //}
}

#pragma mark -
#pragma mark Frame calculations
#define PADDING  10

- (CGRect)frameForPagingScrollView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = [scrollView_ bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}


#pragma mark -
#pragma mark Photo (Page) Management

- (void)loadPhoto:(NSInteger)index
{
    if (index < 0 || index >= photoCount_) {
        return;
    }
    
    id currentPhotoView = [photoViews_ objectAtIndex:index];
    if (NO == [currentPhotoView isKindOfClass:[ImageScrollView class]]) {
        // Load the photo view.
        CGRect frame = [self frameForPageAtIndex:index];
        ImageScrollView *photoView = [[ImageScrollView alloc] initWithFrame:frame];
        //[photoView setBrowserView:self];
        [photoView setIndex:index];
        //[photoView setBackgroundColor:[UIColor clearColor]];
        /*
        // Set the photo image.
        if (dataSource_) {
            if ([dataSource_ respondsToSelector:@selector(imageAtIndex:photoView:)] == NO) {
                UIImage *image = [dataSource_ imageAtIndex:index];
                [photoView setImage:image];
            } else {
                [dataSource_ imageAtIndex:index photoView:photoView];
            }
        }
        */
        [scrollView_ addSubview:photoView];
        [photoViews_ replaceObjectAtIndex:index withObject:photoView];
        
    } else {
        // Turn off zooming.
        [currentPhotoView turnOffZoom];
    }
}

- (void)unloadPhoto:(NSInteger)index
{
    if (index < 0 || index >= photoCount_) {
        return;
    }
    
    ImageScrollView *currentPhotoView = [photoViews_ objectAtIndex:index];
    if ([currentPhotoView isKindOfClass:[ImageScrollView class]]) {
        [currentPhotoView removeFromSuperview];
        [photoViews_ replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
    currentIndex_ = newIndex;
    
    [self loadPhoto:currentIndex_];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadPhoto:currentIndex_ + 1];
        [self loadPhoto:currentIndex_ - 1];
        [self unloadPhoto:currentIndex_ + 2];
        [self unloadPhoto:currentIndex_ - 2];
//    });
    [self setTitleWithCurrentPhotoIndex];
}


#pragma mark -
#pragma mark Rotation Magic
/*
 - (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 CGRect toolbarFrame = toolbar_.frame;
 if ((interfaceOrientation) == UIInterfaceOrientationPortrait || (interfaceOrientation) == UIInterfaceOrientationPortraitUpsideDown) {
 toolbarFrame.size.height = ktkDefaultPortraitToolbarHeight;
 } else {
 toolbarFrame.size.height = ktkDefaultLandscapeToolbarHeight+1;
 }
 
 toolbarFrame.size.width = self.view.frame.size.width;
 toolbarFrame.origin.y =  self.view.frame.size.height - toolbarFrame.size.height;
 toolbar_.frame = toolbarFrame;
 }
 */
- (void)layoutScrollViewSubviews
{
    [self setScrollViewContentSize];
    
    NSArray *subviews = [scrollView_ subviews];
    
    for (ImageScrollView *photoView in subviews) {
        CGPoint restorePoint = [photoView pointToCenterAfterRotation];
        CGFloat restoreScale = [photoView scaleToRestoreAfterRotation];
        [photoView setFrame:[self frameForPageAtIndex:[photoView index]]];
        [photoView setMaxMinZoomScalesForCurrentBounds];
        [photoView restoreCenterPoint:restorePoint scale:restoreScale];
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = scrollView_.bounds.size.width;
    CGFloat newOffset = currentIndex_ * pageWidth;
    scrollView_.contentOffset = CGPointMake(newOffset, 0);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    /*
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = scrollView_.contentOffset.x;
    CGFloat pageWidth = scrollView_.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation_ = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage_ = (offset - (firstVisiblePageIndexBeforeRotation_ * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation_ = 0;
        percentScrolledIntoFirstVisiblePage_ = offset / pageWidth;
    }
    */
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self layoutScrollViewSubviews];
    // Rotate the toolbar.
    //   [self updateToolbarWithOrientation:toInterfaceOrientation];
    
    // Adjust navigation bar if needed.
    /* if (isChromeHidden_ && statusbarHidden_ == NO) {
     UINavigationBar *navbar = [[self navigationController] navigationBar];
     CGRect frame = [navbar frame];
     frame.origin.y = 20;
     [navbar setFrame:frame];
     }
     */
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self startChromeDisplayTimer];
//}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (NO == ROOTVIEW.view.userInteractionEnabled) {
//        //用户在执行删除操作，页面暂时不滚动
//        return;
//    }
    NSInteger page = floor(scrollView.contentOffset.x/scrollView.frame.size.width);//返回一个小于传入参数的最大整数
//  NSInteger page = ceil(scrollView.contentOffset.x/scrollView.frame.size.width);//返回大于或者等于指定表达式的最小整数
    if(page < 0) page = 0;
//    NSLog(@"--滚动");
    if (page != currentIndex_) {
        [self setCurrentIndex:page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"----显示原图--1");
    id currentPhotoView = [photoViews_ objectAtIndex:currentIndex_];
    if ([currentPhotoView isKindOfClass:[ImageScrollView class]]) {
        [currentPhotoView showImage];
    }
}
/*
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"----显示原图--2");
    id currentPhotoView = [photoViews_ objectAtIndex:currentIndex_];
    if ([currentPhotoView isKindOfClass:[ImageScrollView class]]) {
        [currentPhotoView showImage];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
        NSLog(@"----显示原图--3");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging  -  End of Scrolling.");
    if(!decelerate){
        NSLog(@"----显示原图--5");
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //使用这个函数，就可以计算将要滑到的那一点，然后根据这一点的位置/cell的高度，在设置setContentOffset,就可以让tableView滑动整数个，刚刚好停留在某一个cell上，而不是多出半个或者多少像素
    //int moveNum = velocity.y/64;
    //[clv_monthTableView setContentOffset:CGPointMake(0, 64*moveNum) animated:YES];
            NSLog(@"----显示原图--4");
}
*/
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self hideChrome];
//}


#pragma mark -
#pragma mark Toolbar Actions

- (void)nextPhoto
{
    [self scrollToIndex:currentIndex_ + 1];
//    [self startChromeDisplayTimer];
}

- (void)previousPhoto
{
    [self scrollToIndex:currentIndex_ - 1];
//    [self startChromeDisplayTimer];
}

@end
