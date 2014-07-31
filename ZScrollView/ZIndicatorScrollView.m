//
//  ZIndicatorScrollView.m
//  ZScrollView
//

#import "ZIndicatorScrollView.h"

#define kFadePercentage 0.3

@interface ZIndicatorScrollView()
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation ZIndicatorScrollView {
    NSInteger currentIndex;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([self.scrollDataSource respondsToSelector:@selector(numberOfItemsInIndicatorScrollView:)]) {
        [self renderItems];
        _scrollView.delegate      = self;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
    }
    return self;
}

- (void)initScrollView
{
    currentIndex = 0;
    //Init container view
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGFloat width = self.frame.size.width * 0.55;
    CGFloat x = (self.frame.size.width - width)/2;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 0, width, self.frame.size.height)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setClipsToBounds:NO];
    _scrollView.pagingEnabled = YES;
    [_containerView addSubview:_scrollView];
    [self addSubview:_containerView];
}

- (void)renderItems
{
    //Get width and height of scrollview
    NSInteger width = _scrollView.frame.size.width;
    NSInteger height = _scrollView.frame.size.height;
    //Calculate content size
    NSInteger numItems = [self.scrollDataSource numberOfItemsInIndicatorScrollView:self];
    CGRect contentFrame = CGRectMake(0, 0, numItems * width, height);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    _scrollView.contentSize = contentFrame.size;
    
    for (NSInteger i=0; i<numItems; i++) {
        UIView *view = [self.scrollDataSource indicatorScrollView:self viewForItemAtIndex:i];
        //Calculate the position of view
        NSInteger viewWidth  = view.frame.size.width;
        NSInteger viewHeight = view.frame.size.height;
        CGRect frame         = CGRectMake(width*i+(width-viewWidth)/2, (height-viewHeight)/2, viewWidth, viewHeight);
        view.frame           = frame;
        [contentView addSubview:view];
    }
    
    [_scrollView addSubview:contentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat size = scrollView.frame.size.width;
    NSInteger page = floor((_scrollView.contentOffset.x - size/2)/size)+1;
    if (page != currentIndex) {
        currentIndex = page;
        if ([_scrollDelegate respondsToSelector:@selector(indicatorScrollView:didScrollToPage:)]) {
            [_scrollDelegate indicatorScrollView:(ZIndicatorScrollView *)scrollView didScrollToPage:page];
        }
    }
}

//Fade the view from sides
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //Set the fade percentage
    _fadePercentage = _fadePercentage==0?kFadePercentage:_fadePercentage;
    
    id transparent = (id)[[UIColor colorWithWhite:0 alpha:0.4] CGColor];
    id opaque = (id)[[UIColor colorWithWhite:0 alpha:1] CGColor];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame            = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer.startPoint       = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint         = CGPointMake(1.0f, 0.0f);
    gradientLayer.colors           = [NSArray arrayWithObjects:transparent, opaque, opaque, transparent, nil];
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:kFadePercentage],
                               [NSNumber numberWithFloat:1-kFadePercentage],
                               [NSNumber numberWithFloat:1], nil];
    
    [maskLayer addSublayer:gradientLayer];
    self.containerView.layer.mask = maskLayer;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        return _scrollView;
    }
    return nil;
}

@end