//
//  JGJImageCollectionViewCell.h
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
#import "JGJLinePhotoView.h"
@protocol tapCollectionDelegate<NSObject>
-(void)tapCollectionViewSectionAndTag:(NSInteger)currentIndex imagArrs:(NSMutableArray *)imageArrs;
@end
@interface JGJImageCollectionViewCell : UICollectionViewCell
<
tapCollectionViewPhotoDelegate
>
@property(nonatomic ,strong)JGJChatMsgListModel *model;
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property(nonatomic ,strong)NSString *Url_str;
@property(nonatomic ,strong)id <tapCollectionDelegate>delegate;
@property(nonatomic ,strong) JGJLinePhotoView *Simageview;

@end
