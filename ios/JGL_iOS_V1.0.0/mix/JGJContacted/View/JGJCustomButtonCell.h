//
//  JGJCustomButtonCell.h
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJCustomChatButtonCell,
    JGJCustomCallButtonCell,
    JGJCustomJoinBlackButtonCell,
    JGJCustomJoinRemoveBlackListButtonCell,
    JGJCustomDelChatButtonCell,
    JGJCustomAddFriendButtonCell, //加为朋友
    JGJCustomVerifyPassedButtonCell //通过验证
    
} JGJCustomButtonCellType;

@class JGJCustomButtonCell;
@protocol JGJCustomButtonCellDelegate <NSObject>
- (void)customButtonCell:(JGJCustomButtonCell *)cell ButtonCellType:(JGJCustomButtonCellType)buttonCellType;
@end

@interface JGJCustomButtonModel : NSObject
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *layerColor;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) NSString *buttonTitle;
@property (strong, nonatomic) UIColor *backColor;
@property (strong, nonatomic) UIColor *contentBackColor;
@property (assign, nonatomic) JGJCustomButtonCellType buttontype;
@property (assign, nonatomic) BOOL isDefaulStyle;
@property (assign, nonatomic) BOOL isHidden;
@end

@interface JGJCustomButtonCell : UITableViewCell
@property (weak, nonatomic) id <JGJCustomButtonCellDelegate> delegate;
@property (strong, nonatomic) JGJCustomButtonModel *customButtonModel;
@end
