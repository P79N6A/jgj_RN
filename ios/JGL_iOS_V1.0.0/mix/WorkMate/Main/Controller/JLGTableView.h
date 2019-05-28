//
//  JLGTableView.h
//  mix
//
//  Created by jizhi on 15/12/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGTableViewDelegate <NSObject>
- (void)reloadDataCompletion;
@end

@interface JLGTableView : UITableView
@property (nonatomic , weak) id<JLGTableViewDelegate> JLGdelegate;
@end
