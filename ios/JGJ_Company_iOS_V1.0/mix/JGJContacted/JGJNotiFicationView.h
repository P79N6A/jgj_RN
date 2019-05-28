//
//  JGJNotiFicationView.h
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
@protocol TapPhotoItemdelegate<NSObject>

-(void)tapPeopleDetailNewS:(id)object;
@end
@interface JGJNotiFicationView : UIView
@property(nonatomic ,strong)UICollectionView *peopleCollectionview;
@property(nonatomic ,retain)id <TapPhotoItemdelegate> Tapdelegate;

//工头发通知的图片地址数组
@property(nonatomic ,strong)NSArray *WorkheadImage;
@property(nonatomic ,strong)NSMutableArray *HadreciveArray;

@property(nonatomic ,strong)UICollectionView  *headCollectionview;
@property(nonatomic ,strong)UILabel *FromLable;
@property(nonatomic ,strong)UILabel *DepartLable;
@property(nonatomic ,strong)UILabel *NewsLable;
@property(nonatomic ,strong)UIView  *bottomview;
@property(nonatomic ,strong)UIImageView *headImageView;
@property(nonatomic ,strong)UILabel *NameLable;
@property(nonatomic ,strong)UILabel *TimeLable;

@property(nonatomic ,strong)JGJChatMsgListModel *DetailModel;
@end
