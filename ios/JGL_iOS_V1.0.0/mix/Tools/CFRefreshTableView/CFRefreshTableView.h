//
//  CFRefreshTableView.h
//  RepairHelper
//
//  Created by coreyfu on 15/6/4.
//
//

#import <UIKit/UIKit.h>
#import "CFRefreshStatusView.h"
#import "CFRefreshTableViewDefines.h"

@protocol CFRefreshTableViewDelegate <NSObject>
@optional
- (void)CFRefreshTableViewLoadDataSuccess:(CFRefreshTableView *)table;
@end

@interface CFRefreshTableView : UITableView
@property (nonatomic, weak) id<CFRefreshTableViewDelegate> delegateOfTable;

@property (nonatomic, readonly)NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) NSInteger pageLength;
@property (nonatomic, assign) NSInteger pageStart;
@property (nonatomic, copy) NSString *currentUrl;
- (void)loadWithViewOfStatus:(CFRefreshTableviewStatusCallback)statusBlock;

- (void)reset;
- (void)headerBegainRefreshing;
- (void)footerBegainRefreshing;
- (void)changeTableView;
@end
