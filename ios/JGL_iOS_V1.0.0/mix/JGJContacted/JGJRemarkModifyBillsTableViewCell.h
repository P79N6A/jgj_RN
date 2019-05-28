//
//  JGJRemarkModifyBillsTableViewCell.h
//  mix
//
//  Created by Tony on 2017/10/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJRemarkModifyBillsTableViewCellDelegate <NSObject>

-(void)RemarkModifyBillsTextfiledEting:(NSString *)text;

@end
@interface JGJRemarkModifyBillsTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewPlaceConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placeLeftConstances;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImageViewConstance;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleconstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *placelableConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstance;
@property (strong, nonatomic) IBOutlet UIView *topContentConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topRightConstance;

@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLeftConstance;
@property (strong, nonatomic) IBOutlet UILabel *lineLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topDepartConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textviewLeftConstance;

@property (strong, nonatomic) id <JGJRemarkModifyBillsTableViewCellDelegate>delegate;
@end
