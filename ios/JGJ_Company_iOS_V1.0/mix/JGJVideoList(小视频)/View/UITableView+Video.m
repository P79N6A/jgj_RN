//
//  UITableView+Video.m
//  LCTableViewVideoPlay
//
//  Created by lcc on 2017/12/14.
//  Copyright © 2017年 early bird international. All rights reserved.
//

#import "UITableView+Video.h"
//#import "LCVideoCell.h"

#import <objc/runtime.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation UITableView (Video)


#pragma public method
- (void)handleScrollingCellOutScreen{
    
    if ([self playingCellIsOutScreen]) {
        
        TYLog(@"移动到屏幕外，停止播放视频");
        
        JGJVideoListCell *videoCell = self.playingCell;

        JGJVideoListCell *cell = (JGJVideoListCell *)[self getMinCenterCell];

        if ([cell.listModel.post_id isEqualToString:videoCell.listModel.post_id]) {

            videoCell.coverVideoView.alpha = 0;

            videoCell.coverBottomView.alpha = 0;

        }else {

            videoCell.coverVideoView.alpha = 0.7;

            videoCell.coverBottomView.alpha = 0.7;
        
        }

        
    }else {
        
        self.playingCell.coverVideoView.alpha = 0;
        
        self.playingCell.coverBottomView.alpha = 0;
    }
    
}

/* 进行视频自动播放判定逻辑判断 */
- (void)handleScrollPlay{
    
    JGJVideoListCell *cell = (JGJVideoListCell *)[self getMinCenterCell];
    
    if (cell && ![self.playingCell isEqual:cell]) {
        
//        NSLog(@"当前的 cell 存在,是%ld",cell.tag);

        if (self.playingCell) {
            
            JGJVideoListCell *playingCell = (JGJVideoListCell *)self.playingCell;

        }
        
        self.playingCell = cell;
//中间不播放
//        if (self.playingCell.playBlock) {
//
//            self.playingCell.playBlock(nil, self.playingCell.listModel);
//        }
        
    }
    
    cell.coverVideoView.alpha = 0;
    
    cell.coverBottomView.alpha = 0;
    
}

/* 获取距离屏幕最中间的cell */
- (id)getMinCenterCell{
    
    CGFloat minDelta = CGFLOAT_MAX;
    
    //屏幕中央位置
    CGFloat screenCenterY = TYGetUIScreenHeight * 0.5;
    //当前距离屏幕中央最近的cell
    id minCell = nil;
    
    for (JGJVideoListCell *cell in self.visibleCells) {
        
        if ([cell isKindOfClass:[JGJVideoListCell class]]) {
            
            //获取当前 cell 的居中点坐标
//            CGPoint cellCenterPoint = CGPointMake(cell.frame.origin.x, cell.frame.size.height * 0.5 + cell.frame.origin.y);
            //转换当前的 cell 的坐标
            CGPoint coorPoint = [cell.superview convertPoint:cell.center toView:nil];
            
            CGFloat deltaTemp =  fabs(coorPoint.y - screenCenterY);
            
            if (deltaTemp < minDelta) {
                
                minCell = cell;
                
                minDelta = deltaTemp;
                
            }
            
        }
        
    }
    
    return minCell;
    
}

/* 当前播放的视频是否划出屏幕 */
- (BOOL)playingCellIsOutScreen{

    if (!self.playingCell) {
        
        return YES;
    }
    
    JGJVideoListCell *videoCell = (JGJVideoListCell *)self.playingCell;
    
    //当前显示区域内容
    CGRect visiableContentZone = [UIScreen mainScreen].bounds;
    
    //向上滚动
    if(self.scrollDirection == LC_SCROLL_UP){
        
        //找到滚动时候的正在播放视频的cell底部的y坐标点，计算出当前播放的视频是否移除到屏幕外
        CGRect playingCellFrame = videoCell.frame;
        
        //当前正在播放视频的坐标
        CGPoint cellBottomPoint = CGPointMake(playingCellFrame.origin.x, playingCellFrame.size.height + playingCellFrame.origin.y);
        
        //坐标系转换（转换到 window坐标）
        CGPoint coorPoint = [videoCell.superview convertPoint:cellBottomPoint toView:nil];
        
        return CGRectContainsPoint(visiableContentZone, coorPoint);
        
        
    }
    
    //向下滚动
    else if(self.scrollDirection == LC_SCROLL_DOWN){
        
        //找到滚动时候的正在播放视频的cell底部的y坐标点，计算出当前播放的视频是否移除到屏幕外
        CGRect playingCellFrame = videoCell.frame;
        
        //当前正在播放视频的坐标
        CGPoint orginPoint = CGPointMake(playingCellFrame.origin.x, playingCellFrame.origin.y);
        
        //坐标系转换（转换到 window坐标）
        CGPoint coorPoint = [videoCell.superview convertPoint:orginPoint toView:nil];
        
        return CGRectContainsPoint(visiableContentZone, coorPoint);
        
    }
    
    else{
        
        return NO;
    }
    
    
    return YES;
}

#pragma getter and setter

- (void)setScrollDirection:(LCSCROLL_DIRECTION)scrollDirection{
    
    objc_setAssociatedObject(self, @selector(scrollDirection), @(scrollDirection), OBJC_ASSOCIATION_ASSIGN);
    
}

- (LCSCROLL_DIRECTION)scrollDirection{
    
    return [objc_getAssociatedObject(self, _cmd) integerValue];
    
}

- (void)setPlayingCell:(id)playingCell{
    
    objc_setAssociatedObject(self, @selector(playingCell), playingCell, OBJC_ASSOCIATION_RETAIN);
    
}

- (id)playingCell{
    
   return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)centerSepLine{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterSepLine:(UIView *)centerSepLine{

    objc_setAssociatedObject(self, @selector(centerSepLine), centerSepLine, OBJC_ASSOCIATION_RETAIN);
}




@end
