//
//  JGJNoManageProDefaultTableViewCell.h
//  mix
//
//  Created by Tony on 16/4/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJNoManageProDefaultTableViewCell,JGJNoManageProSubStrModel;
@protocol JGJNoManageProDefaultTableViewCellDelegate <NSObject>
- (void )noManageProFindPro:(JGJNoManageProDefaultTableViewCell *)noManageProDefaultCell;
@end

@interface JGJNoManageProDefaultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleProLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *findJobButton;

@property (nonatomic , strong) JGJNoManageProSubStrModel *jgjNoManageProSubStrModel;
@property (nonatomic , weak) id<JGJNoManageProDefaultTableViewCellDelegate> delegate;

@end

@interface JGJNoManageProSubStrModel : NSObject
@property (nonatomic,copy) NSString *subStr;
@property (nonatomic,assign) NSRange subStrRange;
@end
