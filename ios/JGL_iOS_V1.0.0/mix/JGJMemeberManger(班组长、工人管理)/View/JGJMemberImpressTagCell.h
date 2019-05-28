//
//  JGJMemberImpressTagCell.h
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJMemberMangerModel.h"

#import "CustomView.h"

@class JGJMemberImpressTagCell;

@class JGJMemberImpressTagView;

@protocol JGJMemberImpressTagCellDelegate <NSObject>

- (void)impressTagCell:(JGJMemberImpressTagCell *)cell  tagView:(JGJMemberImpressTagView *)tagView sender:(UIButton *)sender;

@end


@interface JGJMemberImpressTagCell : UITableViewCell

@property (nonatomic, assign) JGJMemberImpressTagViewType tagViewType;

//标签模型
@property (nonatomic, strong) NSMutableArray *tagModels;

@property (weak, nonatomic) IBOutlet LineView *topView;

@property (weak, nonatomic) IBOutlet LineView *bottomView;

@property (weak, nonatomic) id <JGJMemberImpressTagCellDelegate> delegate;

@property (nonatomic, strong, readonly) JGJMemberImpressTagView *tagView;
@end
