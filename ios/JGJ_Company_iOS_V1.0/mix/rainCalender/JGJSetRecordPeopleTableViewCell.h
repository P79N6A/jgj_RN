//
//  JGJSetRecordPeopleTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJSetRecordPeopleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UIButton *headBUtton;

@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UIImageView *haveReal;
@property (strong, nonatomic) IBOutlet UIImageView *imageviews;
@property (strong, nonatomic)  JGJSetRainWorkerModel *rainModel;
@property (strong, nonatomic)  UIButton *imageButton;
@property (strong, nonatomic) JGJSynBillingModel *model;

@end
