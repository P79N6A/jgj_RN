//
//  JGJChatOtherListell.h
//  JGJCompany
//
//  Created by Tony on 16/9/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListBaseCell.h"
#import "NSString+Extend.h"

#define kChatListAllDetailCellH 1.0

@interface JGJChatOtherListell : JGJChatListBaseCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameCenterConstance;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *LogClassTypeLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraintH;

@property (nonatomic ,strong)NSIndexPath *indexpath;
@property (strong, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;
- (CGFloat )getTitleSizeHeigt:(NSString *)msg_text;
@end
