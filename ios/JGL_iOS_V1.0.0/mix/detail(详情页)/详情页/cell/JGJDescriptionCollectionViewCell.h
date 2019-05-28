//
//  JGJDescriptionCollectionViewCell.h
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
#import "JGJCoreTextLable.h"
@protocol JGJDescriptionCollectionViewCellDelegate <NSObject>

-(void)openUrlWithWebViewAndUrl:(NSURL *)url;

@end
@interface JGJDescriptionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *DesLable;

@property(nonatomic ,strong)NSString *mjSTR;

@property(nonatomic ,strong)JGJChatMsgListModel *model;

@property (assign, nonatomic)  BOOL taskType;

@property(nonatomic ,strong)id <JGJDescriptionCollectionViewCellDelegate>delegate;

-(float)RowHeight;
@end
