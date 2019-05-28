//
//  JGJAddPeopleToGroupListView.h
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Joindelegate<NSObject>

-(void)ClickjoinGroup;
@end
@interface JGJAddPeopleToGroupListView : UIView
@property(nonatomic ,strong)UICollectionView *peopleCollectionview;
@property(nonatomic ,strong)UIButton         *JoinGrounpButton;
@property(nonatomic ,strong)NSMutableArray   *JoinArray;
@property(nonatomic ,retain)id<Joindelegate>   delegate;

@end
