//
//  JGJContractorListAccountCell.h
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"

@protocol JGJContractorListAccountCellDelegate <NSObject>

- (void)JGJContractorListAccountTextFileEditingText:(NSString *)text cellTag:(NSInteger)cellTag;
- (void)textFieldEndEditing;


@end
@interface JGJContractorListAccountCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, assign) NSInteger cellTag;
@property (assign, nonatomic) int maxLength;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) BOOL isMarkBillMore;// 是否记多人进入
@property (weak, nonatomic) id<JGJContractorListAccountCellDelegate> delegate;

@property (nonatomic, assign) BOOL manGo;
@end
