//
//  UITableView+SFOpenFolder.m
//  UITableView-SFOpenFolder
//
//  Created by Jakey on 2017/3/31.
//  Copyright © 2017年 Jakey. All rights reserved.
//

#import "UITableView+SFOpenFolder.h"
#import  <objc/runtime.h>

static const void *k_sf_table_contentView = &k_sf_table_contentView;
static const void *k_sf_table_open = &k_sf_table_open;
static const void *k_sf_table_animationCells = &k_sf_table_animationCells;
static const void *k_sf_table_animationHeaders = &k_sf_table_animationHeaders;
static const void *k_sf_table_up = &k_sf_table_up;
static const void *k_sf_table_down = &k_sf_table_down;

static const void *k_sf_table_beginningblock = &k_sf_table_beginningblock;
static const void *k_sf_table_completionblock = &k_sf_table_completionblock;
static const void *k_sf_table_contentblock = &k_sf_table_contentblock;

static const void *k_sf_table_selectedindexpath = &k_sf_table_selectedindexpath;
static const void *k_sf_table_duration = &k_sf_table_duration;
static const void *k_sf_table_content_frame = &k_sf_table_content_frame;

@interface UITableView()
@property (strong, nonatomic) NSMutableArray *sf_animationCells;
@property (strong, nonatomic) NSMutableArray *sf_animationHeaders;
@property (assign, nonatomic) CGRect sf_table_content_frame;

//@property (strong, nonatomic) NSMutableArray *sf_animationFooters; //todo

@property (assign, nonatomic) CGFloat sf_table_open_up;
@property (assign, nonatomic) CGFloat sf_table_open_down;
@property (assign, nonatomic) NSTimeInterval sf_table_open_duration;
@property (copy, nonatomic) SFTableBeginningBlock sf_beginningBlock;
@property (copy, nonatomic) SFTableCompletionBlock sf_completionBlock;
@property (copy, nonatomic) SFTableContentViewBlock sf_contentViewBlock;
@end
@implementation UITableView (SFOpenFolder)
#pragma mark -- property
-(NSIndexPath *)sf_selectedIndexPath{
    return objc_getAssociatedObject(self, k_sf_table_selectedindexpath);
}
-(void)setSf_selectedIndexPath:(NSIndexPath *)sf_selectedIndexPath{
    objc_setAssociatedObject(self, k_sf_table_selectedindexpath, sf_selectedIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)sf_contentView{
    return objc_getAssociatedObject(self, k_sf_table_contentView);
}
- (void)setSf_contentView:(UIView *)sf_contentView{
    objc_setAssociatedObject(self, k_sf_table_contentView, sf_contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SFTableOpenStatus)sf_openStatus{
    return (SFTableOpenStatus)[objc_getAssociatedObject(self, k_sf_table_open) integerValue];
}
- (void)setSf_openStatus:(SFTableOpenStatus)sf_openStatus{
    objc_setAssociatedObject(self,k_sf_table_open, @(sf_openStatus), OBJC_ASSOCIATION_ASSIGN);
}
- (NSMutableArray *)sf_animationCells{
    return objc_getAssociatedObject(self, k_sf_table_animationCells);
}
- (void)setSf_animationCells:(NSMutableArray *)sf_animationCells{
    objc_setAssociatedObject(self,k_sf_table_animationCells, sf_animationCells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)sf_animationHeaders{
    return objc_getAssociatedObject(self, k_sf_table_animationHeaders);
}
- (void)setSf_animationHeaders:(NSMutableArray *)sf_animationHeaders{
    objc_setAssociatedObject(self,k_sf_table_animationHeaders, sf_animationHeaders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sf_table_open_up{
    return [objc_getAssociatedObject(self, k_sf_table_up) floatValue];
}
- (void)setSf_table_open_up:(CGFloat)sf_table_open_up{
    objc_setAssociatedObject(self,k_sf_table_up, @(sf_table_open_up), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)sf_table_open_down{
    return [objc_getAssociatedObject(self, k_sf_table_down) floatValue];
}
- (void)setSf_table_open_down:(CGFloat)sf_table_open_down{
    objc_setAssociatedObject(self,k_sf_table_down, @(sf_table_open_down), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SFTableBeginningBlock)sf_beginningBlock{
    return objc_getAssociatedObject(self, k_sf_table_beginningblock);
}
- (void)setSf_beginningBlock:(SFTableBeginningBlock)sf_beginningBlock{
    objc_setAssociatedObject(self,k_sf_table_beginningblock,sf_beginningBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SFTableCompletionBlock)sf_completionBlock{
    return objc_getAssociatedObject(self, k_sf_table_completionblock);
}
- (void)setSf_completionBlock:(SFTableCompletionBlock)sf_completionBlock{
    objc_setAssociatedObject(self,k_sf_table_completionblock,sf_completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SFTableContentViewBlock)sf_contentViewBlock{
    return objc_getAssociatedObject(self, k_sf_table_contentblock);
}
- (void)setSf_contentViewBlock:(SFTableContentViewBlock)sf_contentViewBlock{
    objc_setAssociatedObject(self,k_sf_table_contentblock,sf_contentViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSTimeInterval)sf_table_open_duration{
    return [objc_getAssociatedObject(self, k_sf_table_duration) doubleValue];
}
- (void)setSf_table_open_duration:(NSTimeInterval)sf_table_open_duration{
    objc_setAssociatedObject(self,k_sf_table_duration, @(sf_table_open_duration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGRect)sf_table_content_frame{
    return CGRectFromString([objc_getAssociatedObject(self, k_sf_table_content_frame) description]);
}
- (void)setSf_table_content_frame:(CGRect)sf_table_content_frame{
    objc_setAssociatedObject(self,k_sf_table_content_frame, NSStringFromCGRect(sf_table_content_frame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -
#pragma mark -- Opend Method
- (void)sf_closeViewWithSelectedIndexPath:(void (^)(NSIndexPath *selectedIndexPath))completion

{
    [self sf_closeViewWithIndexPath:self.sf_selectedIndexPath completion:^{
        completion(self.sf_selectedIndexPath);
    }];
}
- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                    contentBlock:(SFTableContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFTableBeginningBlock)sf_beginningBlock
                 completionBlock:(SFTableCompletionBlock)sf_completionBlock{
   return [self sf_openFolderAtIndexPath:indexPath
                          duration:SFTableCellMoveDuration
                      contentBlock:sf_contentViewBlock
                    beginningBlock:sf_beginningBlock
                   completionBlock:sf_completionBlock];
}
- (BOOL)sf_openFolderAtIndexPath:(NSIndexPath *)indexPath
                        duration:(NSTimeInterval)duration
                    contentBlock:(SFTableContentViewBlock)sf_contentViewBlock
                  beginningBlock:(SFTableBeginningBlock)sf_beginningBlock
                 completionBlock:(SFTableCompletionBlock)sf_completionBlock{
    self.sf_beginningBlock = [sf_beginningBlock copy];
    self.sf_completionBlock = [sf_completionBlock copy];
    self.sf_contentViewBlock = [sf_contentViewBlock copy];
    self.sf_selectedIndexPath = indexPath;
    self.sf_table_open_duration = duration;
    
    if (self.sf_openStatus == SFTableOpenStatusOpening) {
        return YES;
    }
    if (self.sf_openStatus ==  SFTableOpenStatusOpened) {
        if (self.sf_beginningBlock) {
            self.sf_beginningBlock(SFTableOpenStatusOpening);
        }
        [self sf_closeViewWithIndexPath:indexPath completion:nil];
    }
    
    if (self.sf_openStatus == SFTableOpenStatusClose) {
        if (self.sf_contentViewBlock) {
            self.sf_contentView = self.sf_contentViewBlock(nil);
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
            self.sf_contentView = view;
        }
        self.sf_table_content_frame = self.sf_contentView.frame;

        if (!self.sf_animationCells) {
            self.sf_animationCells = [NSMutableArray array];
        }
        if (!self.sf_animationHeaders) {
            self.sf_animationHeaders = [NSMutableArray array];
        }
        if (self.sf_beginningBlock) {
            self.sf_beginningBlock(SFTableOpenStatusClosing);
        }
        [self sf_openViewWithSelectIndexPath:indexPath];
        
    }
    //    NSLog(@"open status:%zd",self.sf_openStatus);
    return YES;
}
- (void)sf_openViewWithSelectIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat bottomY = [self sf_offsetBottomWithIndexPath:indexPath];
    //    NSLog(@"bottomY:%lf",bottomY);
    
    if (bottomY >= self.sf_contentView.frame.size.height)
    {
        
        self.sf_table_open_down = self.sf_contentView.frame.size.height;
        [self sf_moveDownFromIndexPath:indexPath];
        //增加contentview
        CGRect selectCellFinalFrame =  [self cellForRowAtIndexPath:indexPath].frame;
        CGFloat contentHeight = self.sf_contentView.frame.size.height;
        self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCellFinalFrame), self.sf_contentView.frame.size.width,0);
        self.sf_contentView.clipsToBounds = YES;
        [self addSubview:self.sf_contentView];
        [UIView animateWithDuration:self.sf_table_open_duration animations:^{
            self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCellFinalFrame), self.sf_contentView.frame.size.width,contentHeight);
        } completion:^(BOOL finished) {
            //完成状态
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFTableOpenStatusOpened);
                self.sf_openStatus = SFTableOpenStatusOpened;
            }
        }];
    }
    else
    {
        //增加contentview
        CGRect selectCelOldFrame =  [self cellForRowAtIndexPath:indexPath].frame;
        self.sf_table_open_up = self.sf_contentView.frame.size.height - bottomY;
        self.sf_table_open_down = bottomY;
        [self sf_moveUPandDownFromIndexPath:indexPath];
        CGRect selectCelFinalFrame =  [self cellForRowAtIndexPath:indexPath].frame;
        
        CGFloat contentHeight = self.sf_contentView.frame.size.height;
        self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCelOldFrame), self.sf_contentView.frame.size.width,0);
        self.sf_contentView.clipsToBounds = YES;
        [self addSubview:self.sf_contentView];
        [UIView animateWithDuration:self.sf_table_open_duration animations:^{
            self.sf_contentView.frame = CGRectMake(0, CGRectGetMaxY(selectCelFinalFrame), self.sf_contentView.frame.size.width,contentHeight);
        } completion:^(BOOL finished) {
            //完成状态
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFTableOpenStatusOpened);
                self.sf_openStatus = SFTableOpenStatusOpened;
            }
        }];
    }
    
    self.scrollEnabled = NO;
}
- (void)sf_moveDownFromIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"直接展开");
    NSArray *visiblePaths = [self jk_visibleCells];
    NSArray *visibleSections = [self jk_indexesOfVisibleSections];
    UITableViewCell *selectCell = (UITableViewCell *)[self cellForRowAtIndexPath:indexPath];
    
    
    [visiblePaths enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        UITableViewCell *moveCell = (UITableViewCell *)[self cellForRowAtIndexPath:path];
        
        if ((path.section > indexPath.section))
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_down isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
        }
        else if ((path.section  == indexPath.section) && (path.row > indexPath.row) && selectCell.frame.origin.y != moveCell.frame.origin.y){
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_down isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
        }
        else
        {
            self.sf_openStatus = SFTableOpenStatusOpened;
        }
        
        if (path.row != indexPath.row)
        {
            //改变当前cell样式;
        }
        
    }];
    
    
    [visibleSections enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger idx, BOOL *stop) {
        
        if (([index integerValue] > indexPath.section ))
        {
            UITableViewHeaderFooterView *sectionHeader = [self headerViewForSection:[index integerValue]];
            
            if (sectionHeader) {
                [self sf_animateView:sectionHeader WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_down isOpening:YES];
                [self.sf_animationHeaders addObject:sectionHeader];
            }
        }
    }];
}
- (void)sf_moveUPandDownFromIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"移动展开");
    NSArray *visiblePaths = [self jk_visibleCells];
    NSArray *visibleSections = [self jk_indexesOfVisibleSections];
    UITableViewCell *selectCell = (UITableViewCell *)[self cellForRowAtIndexPath:indexPath];
    
    CGRect selectCellFrame = selectCell.frame;
    
    
    [visiblePaths enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        UITableViewCell *moveCell = (UITableViewCell *)[self cellForRowAtIndexPath:path];
        
        if ((path.section < indexPath.section))
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_up isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
            
        }
        else if ((path.section  == indexPath.section))
        {
            //                NSLog(@"{selecct: %zd,%zd}",indexPath.section,indexPath.row);
            //                NSLog(@"{move:%zd,%zd}",path.section,path.row);
            
            if ((path.row <= indexPath.row)) {
                [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_up isOpening:YES];
                [self.sf_animationCells addObject:moveCell];
                
            }else{
                CGRect m =  moveCell.frame;
                if ((m.origin.y  - selectCellFrame.origin.y != 0)) {
                    [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_down isOpening:YES];
                    [self.sf_animationCells addObject:moveCell];
                }else{
                    [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_up isOpening:YES];
                    [self.sf_animationCells addObject:moveCell];
                }
            }
        }
        else
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_down isOpening:YES];
            [self.sf_animationCells addObject:moveCell];
        }
        if (path.row != indexPath.row)
        {
            //改变当前cell样式;
        }
        //        //完成状态
        //        if ((moveCell == [self.sf_animationCells lastObject]) && self.sf_completionBlock) {
        //            self.sf_completionBlock(SFOpenStatusOpened);
        //            self.sf_openStatus = SFOpenStatusOpened;
        //        }
    }];
    
    [visibleSections enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger idx, BOOL *stop) {
        UITableViewHeaderFooterView *sectionHeader = [self headerViewForSection:[index integerValue]];
        
        if (sectionHeader)
        {
            if (([index integerValue] < indexPath.section))
            {
                [self sf_animateView:sectionHeader WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_up isOpening:YES];
            }else if ([index integerValue]  == indexPath.section) {
                [self sf_animateView:sectionHeader WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_up isOpening:YES];
            }else{
                [self sf_animateView:sectionHeader WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_down isOpening:YES];
            }
            [self.sf_animationHeaders addObject:sectionHeader];
        }
    }];
}

#pragma mark -
#pragma mark -- Close Method
- (void)sf_closeViewWithIndexPath:(NSIndexPath *)indexPath completion:(void (^)(void))completion
{
    if (self.sf_openStatus == SFTableOpenStatusClose) {
        if (completion) {
            completion();
        }
        NSLog(@"折叠section");
        return;
    }
    NSLog(@"关闭");
    [self.sf_animationCells enumerateObjectsUsingBlock:^(UICollectionViewCell *moveCell, NSUInteger idx, BOOL *stop) {
        if (moveCell.sf_direction == SFTableMoveDirectionUp)
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_up isOpening:NO];
        }
        else
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_down  isOpening:NO];
        }
    }];
    
    
    [self.sf_animationHeaders enumerateObjectsUsingBlock:^(UICollectionReusableView *moveCell, NSUInteger idx, BOOL *stop) {
        if (moveCell.sf_direction == SFTableMoveDirectionUp)
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionDown distance:self.sf_table_open_up  isOpening:NO];
        }
        else
        {
            [self sf_animateView:moveCell WithDirection:SFTableMoveDirectionUp distance:self.sf_table_open_down  isOpening:NO];
        }
    }];
    

    if (self.sf_table_open_up==0) {
        [UIView animateWithDuration:self.sf_table_open_duration animations:^{
            self.sf_contentView.frame = CGRectMake(self.sf_contentView.frame.origin.x, self.sf_contentView.frame.origin.y, self.sf_contentView.frame.size.width,0);
        } completion:^(BOOL finished) {
            self.sf_contentView.frame = self.sf_table_content_frame;
            [self.sf_contentView removeFromSuperview];
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFTableOpenStatusClose);
                self.sf_openStatus = SFTableOpenStatusClose;
            }
            if (completion) {
                completion();
            }
        }];
    }else{
        [UIView animateWithDuration:self.sf_table_open_duration animations:^{
            CGRect frame = self.sf_contentView.frame;
            frame.origin.y = frame.origin.y + self.sf_table_open_up;
            self.sf_contentView.frame = frame;
            [UIView animateWithDuration:self.sf_table_open_duration animations:^{
                CGRect frame = self.sf_contentView.frame;
                frame.size.height = 0;
                self.sf_contentView.frame = frame;
            } completion:^(BOOL finished) {
                self.sf_contentView.frame = self.sf_table_content_frame;
                [self.sf_contentView removeFromSuperview];
            }];
        } completion:^(BOOL finished) {
            self.sf_contentView.frame = self.sf_table_content_frame;
            [self.sf_contentView removeFromSuperview];
            if (self.sf_completionBlock) {
                self.sf_completionBlock(SFTableOpenStatusClose);
                self.sf_openStatus = SFTableOpenStatusClose;
            }
            if (completion) {
                completion();
            }
        }];
    }
    
    
    //    NSArray *paths = [collectionView indexPathsForVisibleItems];
    //    for (NSIndexPath *path in paths)
    //    {
    //      //更改除选中cell之外的cell样式
    //    }
    [self sf_clean];
}
- (void)sf_clean{
    self.sf_table_open_up = 0;
    self.sf_table_open_down = 0;
    self.sf_selectedIndexPath = nil;
    self.scrollEnabled = YES;
    [self.sf_animationCells removeAllObjects];
    [self.sf_animationHeaders removeAllObjects];
}

#pragma mark -
#pragma mark Actions
- (CGFloat)sf_offsetBottomWithIndexPath:(NSIndexPath *)indexPath
{
    //    CGFloat screenHeight = SFScreenHeight - SFNaviBarHeight;
    CGFloat screenHeight = self.frame.size.height;
    CGRect cellFrame = [self cellForRowAtIndexPath:indexPath].frame;;
    CGFloat frameY = cellFrame.origin.y;
    CGFloat offY = self.contentOffset.y;
    CGFloat bottomY = screenHeight - (frameY - offY) - cellFrame.size.height;
    return bottomY;
}

- (void)sf_animateView:(UIView *)view WithDirection:(SFTableMoveDirection)direction distance:(CGFloat)dis isOpening:(BOOL)isOpening
{
    CGRect newFrame = view.frame;
    view.sf_direction = direction;
    switch (direction)
    {
        case SFTableMoveDirectionUp:
            newFrame.origin.y -= dis;
            break;
        case SFTableMoveDirectionDown:
            newFrame.origin.y += dis;
            break;
        default:NSAssert(NO, @"无法识别的方向");
            break;
    }
    
    if (isOpening) {
        self.sf_openStatus = SFTableOpenStatusOpening;
    }else{
        self.sf_openStatus = SFTableOpenStatusClosing;
    }
    
    [UIView animateWithDuration:self.sf_table_open_duration
                     animations:^{
                         view.frame = newFrame;
                     } completion:^(BOOL finished) {
                         //                         if (isOpening) {
                         //                             self.sf_openStatus = SFOpenStatusOpened;
                         //                         }else{
                         //                             self.sf_openStatus = SFOpenStatusClose;
                         //                         }
                     }];
}





















#pragma mark -- helper
- (NSArray *)jk_indexesOfVisibleSections {
    // Note: We can't just use indexPathsForVisibleRows, since it won't return index paths for empty sections.
    NSMutableArray *visibleSectionIndexes = [NSMutableArray arrayWithCapacity:self.numberOfSections];
    for (int i = 0; i < self.numberOfSections; i++) {
        CGRect headerRect;
        // In plain style, the section headers are floating on the top, so the section header is visible if any part of the section's rect is still visible.
        // In grouped style, the section headers are not floating, so the section header is only visible if it's actualy rect is visible.
        if (self.style == UITableViewStylePlain) {
            headerRect = [self rectForSection:i];
        } else {
            headerRect = [self rectForHeaderInSection:i];
        }
        // The "visible part" of the tableView is based on the content offset and the tableView's size.
        CGRect visiblePartOfTableView = CGRectMake(self.contentOffset.x, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
        if (CGRectIntersectsRect(visiblePartOfTableView, headerRect)) {
            [visibleSectionIndexes addObject:@(i)];
        }
    }
    return visibleSectionIndexes;
}

- (NSArray *)jk_visibleHeaders {
    NSMutableArray *visibleSects = [NSMutableArray arrayWithCapacity:self.numberOfSections];
    for (NSNumber *sectionIndex in self.jk_indexesOfVisibleSections) {
        UITableViewHeaderFooterView *sectionHeader = [self headerViewForSection:sectionIndex.intValue];
        [visibleSects addObject:sectionHeader];
    }
    
    return visibleSects;
}
-(NSArray *)jk_visibleCells
{
    NSInteger sections = self.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [self numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];   // **here, for those cells not in current screen, cell is nil**
            if (cell) {
                [cells addObject:indexPath];
            }
        }
    }
    return cells;
}

@end

static const void *k_sf_open_table_direction = &k_sf_open_table_direction;

@implementation UIView (SFOpenFolderDirection)
- (SFTableMoveDirection)sf_direction{
    return (SFTableMoveDirection)[objc_getAssociatedObject(self, k_sf_open_table_direction) integerValue];
}
- (void)setSf_direction:(SFTableMoveDirection)sf_direction{
    objc_setAssociatedObject(self,k_sf_open_table_direction, @(sf_direction), OBJC_ASSOCIATION_ASSIGN);
}
@end
