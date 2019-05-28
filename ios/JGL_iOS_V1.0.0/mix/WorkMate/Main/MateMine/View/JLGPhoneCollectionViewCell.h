//
//  JLGPhoneCollectionViewCell.h
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class JLGPhoneCollectionViewCell;
@protocol JLGPhoneCollectionViewCellDelegate <NSObject>
@optional
- (void)deleteBtnClick:(JLGPhoneCollectionViewCell *)phoneCollectionCell;
@end

@interface JLGPhoneCollectionViewCell : UICollectionViewCell
@property (nonatomic , weak) id<JLGPhoneCollectionViewCellDelegate> delegate;

- (IBAction)deleteBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

@property (nonatomic,copy)   NSString *picUrl;
@property (nonatomic,strong) UIImage *backImage;
@property (nonatomic,assign) BOOL showDeleteButton;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
