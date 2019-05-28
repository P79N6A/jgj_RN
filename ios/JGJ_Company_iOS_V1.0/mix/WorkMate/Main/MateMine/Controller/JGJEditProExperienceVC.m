//
//  JGJEditProExperienceVC.m
//  mix
//
//  Created by yj on 16/6/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJEditProExperienceVC.h"
#import "JLGRegisterInfoTableViewCell.h"
#import "JLGRegisterClickTableViewCell.h"
#import "JLGAddProExperienceTableViewCell.h"
#import "JLGSendProjectTableViewCell.h"
#import "JGJEditProExperienceCell.h"
#import "UILabel+GNUtil.h"
@interface JLGAddProExperienceViewController () <JLGMYProExperienceTableViewCellDelegate, JLGSendProjectTableViewCellDelegate>

@property (nonatomic, strong) JGJEditProExperienceCell *ProExperienceCell;
@end
@implementation JGJEditProExperienceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"晒手艺";
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
        cell.imagesArray = self.imagesArray;
        return cell.cellHeight;
    }else if(indexPath.row == 3){
        return 70;
    }
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *title = nil;
    NSString *desTitle = nil;
    switch (indexPath.row) {
        case 0:
        {
            cell = [JGJEditProExperienceCell cellWithTableView:tableView];
            JGJEditProExperienceCell *returnCell = (JGJEditProExperienceCell *)cell;
            returnCell.proDes.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
            desTitle = self.addProExperienceInfo[[self getKeyByIndexPath:indexPath]];
            title = self.authoInfosArray[indexPath.section][indexPath.row][0];
            returnCell.proDes.text = title;
            returnCell.proDesDetail.text = desTitle ?:@"";
            return returnCell;
        }
            break;
        case 1:
        {
            cell = [JGJEditProExperienceCell cellWithTableView:tableView];
            JGJEditProExperienceCell *returnCell = (JGJEditProExperienceCell *)cell;
            desTitle = [self.addProExperienceInfo[[self getKeyByIndexPath:indexPath]] stringByAppendingString:self.addProExperienceInfo[[self getKeyByIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]]]];
            title = self.authoInfosArray[indexPath.section][indexPath.row][0];
            returnCell.proDes.text = title;
            returnCell.proDesDetail.text = desTitle ?:@"";
            
            return returnCell;
        }
            break;
        case 2:
        {
            cell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
            JLGAddProExperienceTableViewCell *returnCell = (JLGAddProExperienceTableViewCell *)cell;
            
            returnCell.delegate = self;
            returnCell.imagesArray = self.imagesArray;
            
            __weak typeof(self) weakSelf = self;
            returnCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
                [weakSelf removeImageAtIndex:index];
                
                //取出url
                __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
                [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        [deleteUrlArray addObject:obj];
                    }
                }];
                [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
                [weakSelf.tableView reloadData];
            };
            
            return returnCell;
        }
            break;
        case 3:
        {
            JLGSendProjectTableViewCell *returnCell = [JLGSendProjectTableViewCell cellWithTableView:tableView];
            returnCell.delegate = self;
            returnCell.titleString = @"保存";
            returnCell.backgroundColor = [UIColor whiteColor];
            
            return returnCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

@end
