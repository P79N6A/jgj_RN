//
//  JGJRecordDetailmageLinTableViewCell.h
//  mix
//
//  Created by Tony on 2017/9/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJLinePhotoView.h"
@protocol tapCollectionDelegate<NSObject>
-(void)tapCollectionViewSectionAndTag:(NSInteger)currentIndex imagArrs:(NSMutableArray *)imageArrs;
@end
@interface JGJRecordDetailmageLinTableViewCell : UITableViewCell
<
tapCollectionViewPhotoDelegate
>
@property(nonatomic ,strong)id <tapCollectionDelegate>delegate;

@property(nonatomic, strong)NSArray *imageArr;

@property(nonatomic, assign)BOOL origionX;

@end
