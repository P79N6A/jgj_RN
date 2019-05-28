//
//  JLGAddProExperienceViewController.h
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIPhotoViewController.h"
#import "JLGRegisterInfoTableViewCell.h"
#import "JLGRegisterClickTableViewCell.h"
@interface JLGAddProExperienceViewController : UIPhotoViewController
@property (nonatomic,assign) BOOL isBackLevel;//YES:直接返回堆栈的上一级，NO,返回两级，暂时没有用了，需要用的时候再打开
@property (nonatomic,strong) NSMutableDictionary *parametersDic;//用于上传
@property (nonatomic,copy)   NSArray *imageUrlArray;
@property (nonatomic,strong) NSMutableDictionary *addProExperienceInfo;//用于显示

@property (nonatomic,copy) NSString *pid;//有pid说明是修改项目，没有pid说明是发布项目
@property (nonatomic,copy)   NSArray *authoInfosArray;
@property (nonatomic,strong) NSMutableArray *deleteImgsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)setRegisterInfoCellDetailTF:(JLGRegisterInfoTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath;
- (void )setRegisterClickCellDetailTF:(JLGRegisterClickTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath;
- (void)blockWithCell:(JLGRegisterInfoTableViewCell *)returnCell;
- (NSString *)getKeyByIndexPath:(NSIndexPath *)indexPath;

- (void )CollectionCellDidSelected:(NSUInteger )cellIndex imageIndex:(NSUInteger )imageIndex;

- (void)subClassTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
