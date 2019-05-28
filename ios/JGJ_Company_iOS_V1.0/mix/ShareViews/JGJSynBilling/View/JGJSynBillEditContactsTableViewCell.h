//
//  JGJSynBillEditContactsTableViewCell.h
//  mix
//
//  Created by jizhi on 16/5/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"

@class JGJSynBillEditContactsTableViewCell;
typedef void(^SynBillEditContactsSaveBlock)(JGJSynBillEditContactsTableViewCell *cell);

@interface JGJSynBillEditContactsTableViewCell : UITableViewCell
@property (nonatomic, strong)  JGJSynBillingModel *synBillingModel;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *descriptionTF;

- (void)SynBillEditContactsSaveBlock:(SynBillEditContactsSaveBlock )saveBlock;

@end
