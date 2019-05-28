//
//  JGJWaringSuggustTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJWaringSuggustTableViewCellDelegate <NSObject>

- (void)clickLookforDetailBtn;

@end
@interface JGJWaringSuggustTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;

@property (strong, nonatomic) IBOutlet UIButton *lookBtn;

@property (strong, nonatomic)id <JGJWaringSuggustTableViewCellDelegate>delegate;
@end
