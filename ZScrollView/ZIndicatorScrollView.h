//
//  ZIndicatorScrollView.h
//  ZScrollView
//

#import <UIKit/UIKit.h>

@class ZIndicatorScrollView;
@protocol ZIndicatorScrollViewDataSource <NSObject>
@required
//Fetch the number of items in the indicator view
- (NSInteger)numberOfItemsInIndicatorScrollView:(ZIndicatorScrollView *)scrollView;
//Fetch view for a specific index
- (UIView *)indicatorScrollView:(ZIndicatorScrollView *)scrollView viewForItemAtIndex:(NSInteger)index;
@end

@protocol ZIndicatorScrollViewDelegate <NSObject>
//
- (void)indicatorScrollView:(ZIndicatorScrollView *)scrollView didScrollToPage:(NSInteger)page;
@end

@interface ZIndicatorScrollView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) id<ZIndicatorScrollViewDataSource> scrollDataSource;
@property (strong, nonatomic) id<ZIndicatorScrollViewDelegate> scrollDelegate;
@property (nonatomic) CGFloat fadePercentage;
@end
