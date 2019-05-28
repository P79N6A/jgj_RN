//
//  JGJBrrowOrTotalTableViewCell.h
//  mix
//
//  Created by Tony on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJBrrowOrTotalTableViewCellDelegate <NSObject>

-(void)JGJBrrowOrTotalTextfiledEdite:(NSString *)text andtextTag:(NSInteger)tag;

@end
@interface JGJBrrowOrTotalTableViewCell : UITableViewCell
<
UITextFieldDelegate
>

@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UITextField *textfiled;
@property (strong, nonatomic) id <JGJBrrowOrTotalTableViewCellDelegate>delegate;

@end
