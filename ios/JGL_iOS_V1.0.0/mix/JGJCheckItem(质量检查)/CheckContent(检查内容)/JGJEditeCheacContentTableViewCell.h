//
//  JGJEditeCheacContentTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJEditeCheacContentTableViewCellDelegate <NSObject>
//编辑输入框
-(void)JGJEditeCheacContentTextviewEdite:(NSString *)text andTag:(NSInteger)indexpathRow;
//删除按钮
-(void)JGJEditeCheacContentClickDeleteButtonWithTag:(NSInteger)indexpathRow;

@end
@interface JGJEditeCheacContentTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic)  id <JGJEditeCheacContentTableViewCellDelegate> delegate;
@property (strong, nonatomic) JGJCheckContentListModel *contentModel;

@end
