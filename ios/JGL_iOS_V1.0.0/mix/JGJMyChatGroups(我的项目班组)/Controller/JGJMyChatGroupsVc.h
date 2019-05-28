//
//  JGJMyChatGroupsVc.h
//  mix
//
//  Created by yj on 2019/3/6.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JGJMyChatGroupsVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic,strong ,readonly) UICollectionView *collectionView;

//返回到popVc控制器

@property (nonatomic, strong) UIViewController *popVc;


/**
 群聊类型(班组or项目)
 */
@property (nonatomic, copy) NSString *classType;


@end

NS_ASSUME_NONNULL_END
