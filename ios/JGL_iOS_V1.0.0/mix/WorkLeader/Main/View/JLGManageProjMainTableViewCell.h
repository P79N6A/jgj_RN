//
//  JLGManageProjMainTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGMPModel.h"
#import "JGJFindJobAndProTableViewCell.h"
//#import "JLGFPGoToWorkTableViewCell.h"

typedef NS_ENUM(NSUInteger, selectedType) {
    selectedTypeFullSendAgain = 0,
    selectedTypeFullDealApply,
    selectedTypeNoFullIsFull,
    selectedTypeNoFullRefresh ,
    selectedTypeNoFullModify,
    selectedTypeNoFullDealApply
};
@protocol JLGManageProjMainTableViewCellDelegate <NSObject>
- (void)MPMainCellBtnClick:(selectedType )selectedType indexPath:(NSInteger )index;
@end

@interface JLGManageProjMainTableViewCell : UITableViewCell
//model
@property (nonatomic,strong) JLGMPModel *jlgMPModel;

@property (nonatomic,assign) BOOL isGetCellHeight;
//cell高度使用
@property (nonatomic,assign) CGFloat excludeContentH;//除了中间需要根据内容变化的高度

@property (nonatomic , weak) id<JLGManageProjMainTableViewCellDelegate> delegate;
- (void)setDealApplyButton:(JLGMPModel *)jlgMPModel;

@end
