//
//  UITableView+SFOpenFolder.h
//  UITableView-SFOpenFolder
//
//  Created by Jakey on 2017/3/31.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SFNaviBarHeight 64
#define SFTableCellMoveDuration 0.5

typedef NS_ENUM(NSInteger, SFTableMoveDirection) {
    SFTableMoveDirectionUp = 1,
    SFTableMoveDirectionDown
};

typedef NS_ENUM(NSInteger, SFTableOpenStatus) {
    SFTableOpenStatusClose = 0,
    SFTableOpenStatusOpening = 1,
    SFTableOpenStatusClosing = 2,
    SFTableOpenStatusOpened = 3
};

typedef void(^SFTableBeginningBlock)(SFTableOpenStatus openTableStatus);
typedef void(^SFTableCompletionBlock)(SFTableOpenStatus openTableStatus);
typedef UIView* (^SFTableContentViewBlock)(id item);


@interface UITableView (SFOpenFolder)
@property (nonatomic,strong) UIView *sf_contentView;
@property (assign, nonatomic) SFTableOpenStatus sf_openStatus;
@property (strong, nonatomic) NSIndexPath *sf_selectedIndexPath;

- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                    contentBlock:(SFTableContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFTableBeginningBlock)sf_beginningBlock
                 completionBlock:(SFTableCompletionBlock)sf_completionBlock;


- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                        duration:(NSTimeInterval)duration
                    contentBlock:(SFTableContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFTableBeginningBlock)sf_beginningBlock
                 completionBlock:(SFTableCompletionBlock)sf_completionBlock;

- (void)sf_closeViewWithSelectedIndexPath:(void (^)(NSIndexPath *selectedIndexPath))completion;
- (void)sf_closeViewWithIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion;

#pragma mark -- helper
- (NSArray *)jk_indexesOfVisibleSections;
- (NSArray *)jk_visibleHeaders;
- (NSArray *)jk_visibleCells;
@end


@interface UIView (SFOpenFolderDirection)
@property (assign, nonatomic) SFTableMoveDirection sf_direction;
@end
