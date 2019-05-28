//
//  JGJNewMarkBillProjectListCell.h
//  mix
//
//  Created by Tony on 2018/6/1.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJNewMarkBillProjectModel.h"

#import "TYTextField.h"

@class JGJNewMarkBillProjectListCell;

@protocol JGJNewMarkBillProjectListCellDelegate <NSObject>

@optional
- (void)modifyProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel cell:(JGJNewMarkBillProjectListCell *)cell;
- (void)deleteProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel;
- (void)saveProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel isEqualProjectName:(BOOL)isEqualProjectName;
- (void)saveProjectWithProjectModel:(JGJNewMarkBillProjectModel *)projectModel isEqualProjectName:(BOOL)isEqualProjectName editeName:(NSString *)editeBame;

@end
@interface JGJNewMarkBillProjectListCell : UITableViewCell

@property (nonatomic, strong) LengthLimitTextField *contentField;
@property (nonatomic, weak) id<JGJNewMarkBillProjectListCellDelegate> projectListCellDelegate;

@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, strong) JGJNewMarkBillProjectModel *projectModel;

@property (nonatomic, strong) NSString *selectedProjectName;
@property (nonatomic, assign) BOOL isMarkSingleBillComeIn;// 是否是记单笔进来
- (void)startEdite;
- (void)endEdite;
@end
