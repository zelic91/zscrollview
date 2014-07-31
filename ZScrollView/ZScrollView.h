//
//  ZScrollView.h
//  ZScrollView
//

#import <UIKit/UIKit.h>

@class ZScrollView;

@protocol ZScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInScrollView:(ZScrollView *)scrollView;
- (UIView *)scrollView:(ZScrollView *)scrollView viewForItemAtIndex:(NSInteger)index;
@end

@protocol ZScrollViewDelegate <NSObject>
@optional
- (void)scrollView:(ZScrollView *)scrollView didScrollToPage:(NSInteger)page;
- (void)scrollView:(ZScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;
@end

@interface ZScrollView : UIScrollView<UIScrollViewDelegate>
@property (strong, nonatomic) id<ZScrollViewDataSource> scrollDataSource;
@property (strong, nonatomic) id<ZScrollViewDelegate  > scrollDelegate;
@property (nonatomic) CGFloat space;
@property (strong, nonatomic) NSMutableArray *items;
@end
