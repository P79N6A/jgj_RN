//
//  JGJCheacContentTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"
@protocol JGJCheacContentTableViewCellDelegate <NSObject>

-(void)JGJCheckContentTextfiledEdite:(NSString *)text;

-(void)JGJCheckContentTextfiledEdite:(NSString *)text andTag:(NSInteger)indexRow;


@end
@interface JGJCheacContentTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet LengthLimitTextField *textFiled;
@property (strong, nonatomic)  id <JGJCheacContentTableViewCellDelegate> delegate;

@end
