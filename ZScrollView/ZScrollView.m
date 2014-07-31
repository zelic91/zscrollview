//
//  GScrollView.m
//  GenesisGym
//

#import "ZScrollView.h"

@implementation ZScrollView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([self.scrollDataSource respondsToSelector:@selector(numberOfItemsInScrollView:)]) {
        [self renderItems];
        self.delegate      = self;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)setSpace:(CGFloat)space
{
    _space = space;
    [self setNeedsDisplay];
}

- (void)renderItems
{
    //Calculate content size
    NSInteger numItems = [self.scrollDataSource numberOfItemsInScrollView:self];
    //Calculate position of each item
    NSInteger x = 0;
    for (NSInteger i=0; i<numItems; i++) {
        UIView *view = [self.scrollDataSource scrollView:self viewForItemAtIndex:i];
        
        //Calculate the position of view
        NSInteger viewWidth  = view.frame.size.width;
        NSInteger viewHeight = view.frame.size.height;
        NSInteger y = (self.frame.size.height-viewHeight)/2;
        CGRect frame         = CGRectMake(x, y, viewWidth, viewHeight);
        view.tag = i;
        view.frame           = frame;
        [view setUserInteractionEnabled:YES];
        
        //Set up tap handler
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectEvent:)];
        [view addGestureRecognizer:recognizer];
        
        [_items addObject:view];
        x += viewWidth;
        if (i < numItems - 1) {
            x+=_space;
        }
    }
    
    //Add items to contentView
    NSInteger contentWidth = x;
    NSInteger contentHeight = self.frame.size.height;
    CGRect contentFrame = CGRectMake(0, 0, contentWidth, contentHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    
    for (UIView *view in _items) {
        [contentView addSubview:view];
    }
    
    self.contentSize = contentFrame.size;
    [self addSubview:contentView];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraints:@[leftConstraint, rightConstraint]];
}

- (void)handleSelectEvent:(UITapGestureRecognizer *)recognizer
{
    if ([_scrollDelegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
        [_scrollDelegate scrollView:self didSelectItemAtIndex:recognizer.view.tag];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat size = scrollView.frame.size.width;
    NSInteger page = floor((self.contentOffset.x - size/2)/size)+1;
    
    if ([_scrollDelegate respondsToSelector:@selector(scrollView:didScrollToPage:)]) {
        [_scrollDelegate scrollView:(ZScrollView *)scrollView didScrollToPage:page];
    }
}

@end
