//
//  JGJMemeberMangerCell.h
//  mix
//
//  Created by yj on 2018/11/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    EvaBtnType = 1, //评价按钮
    
    checkAccountBtnType //对账按钮
    

} JGJMemeberMangerCellBtnType;

@class JGJMemeberMangerCell;

@protocol JGJMemeberMangerCellDelegate <NSObject>

- (void)memeberMangerCell:(JGJMemeberMangerCell *)cell btnType:(JGJMemeberMangerCellBtnType)btnType;

@end

@interface JGJMemeberMangerCell : UITableViewCell

//工人班组长管理
@property (nonatomic, copy) JGJSynBillingModel *workerManger;

@property (nonatomic, copy) NSString *searchValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trail;

@property (weak, nonatomic) id <JGJMemeberMangerCellDelegate> delegate;

//当前是删除状态还是取消状态

@property (assign, nonatomic) BOOL isCancelStatus;

@end
