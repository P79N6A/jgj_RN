//
//  JGJImageModelView.h
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImageModelViewHeight  48.0

@protocol ClickPeopleItemButtondelegate<NSObject>
-(void)ClickPeopleItem:(NSMutableArray *)ModelArray anIndexpath:(NSIndexPath *)indexpath deleteObeject:(JGJSynBillingModel *)deleteModel;
@end
@interface JGJImageModelView : UIView
@property(nonatomic ,strong)UICollectionView *peopleCollectionview;
@property(nonatomic ,retain)id <ClickPeopleItemButtondelegate> peopledelegate;
@property(nonatomic ,strong)NSMutableArray *DataMutableArray;
@property (nonatomic, strong) JGJSynBillingModel *DataNameModel;
@end
