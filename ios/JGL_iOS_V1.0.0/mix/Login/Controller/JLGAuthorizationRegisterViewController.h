//
//  JLGAuthorizationRegisterViewController.h
//  mix
//
//  Created by Tony on 16/1/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAuthorizationViewController.h"
#import "TYLoadingHub.h"
#import "JLGBuildAreaTableViewCell.h"
#import "JLGRegisterHeadPicTableViewCell.h"

@interface JLGAuthorizationRegisterViewController : JLGAuthorizationViewController
<
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    JLGRegisterSexTableViewCellDelegate,
    JLGRegisterHeadPicTableViewCellDelegate
>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) JLGCityPickerView *cityPickerView;
@property (nonatomic,strong) NSMutableArray *workTypesSelectArray;//点击为1，不点击为0
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomH;

- (BOOL )checkBaseData;
- (void)popToSuperVc;
- (UITableViewCell *)returnCellByTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
