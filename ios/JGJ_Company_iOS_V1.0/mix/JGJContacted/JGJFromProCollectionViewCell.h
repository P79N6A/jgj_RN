//
//  JGJFromProCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/7/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tapProdelegate <NSObject>
-(void)tapFromLable;
@end
@interface JGJFromProCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *changeProButton;
@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;
@property (strong, nonatomic) IBOutlet UILabel *FromLable;
@property (nonatomic,strong) id <tapProdelegate>delegate;

@end
