//
//  JGJChatListAllDetailVc.m
//  mix
//
//  Created by Tony on 2016/11/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListAllDetailVc.h"
#import "JGJChatListAllDetailCell.h"
#import "UITableView+TYSeparatorLine.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface JGJChatListAllDetailVc ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    JGJChatListBaseCellDelegate
>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JGJChatListAllDetailVc

- (void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel{
    _jgjChatListModel = jgjChatListModel;
    
    NSString *titleStr = @"";
    switch (_jgjChatListModel.chatListType) {
        case JGJChatListNotice:
            titleStr = @"通知";
            break;
        case JGJChatListSafe:
            titleStr = @"安全隐患";
            break;
        case JGJChatListLog:
            titleStr = @"工作日志";
            break;
        case JGJChatListQuality:
            titleStr = @"质量";
            break;
        default:
            break;
    }
    self.title = [NSString stringWithFormat:@"%@详情",titleStr];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(self.view);
        }];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        [_tableView registerNib:[UINib nibWithNibName:@"JGJChatListAllDetailCell" bundle:nil] forCellReuseIdentifier:@"JGJChatListAllDetailCell"];
        
        [UITableView hiddenExtraCellLine:self.tableView];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGJChatListAllDetailCell *detailCell = [JGJChatListAllDetailCell cellWithTableView:tableView];
    
    detailCell.jgjChatListModel = self.jgjChatListModel;
    detailCell.delegate = self;
    return detailCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHegiht = 0;
    cellHegiht = [tableView fd_heightForCellWithIdentifier:@"JGJChatListAllDetailCell" configuration:^(JGJChatListAllDetailCell *chatCell) {
        chatCell.jgjChatListModel = self.jgjChatListModel;
    }];

    return cellHegiht;
}


#pragma mark - cell的delegate
- (void)DidSelectedPhoto:(JGJChatListBaseCell *)chatListCell index:(NSInteger )index image:(UIImage *)image{
    self.imageSelectedIndex = index;
    
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    
    return self.jgjChatListModel.msg_src.count;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    JGJChatMsgListModel *chatListModel = self.jgjChatListModel;
    
    NSMutableArray *imagesArr = chatListModel.msg_src.mutableCopy;
    
    NSMutableArray *LGPhotoPickerBrowserURLArray = [[NSMutableArray alloc] init];
    for (id pic in imagesArr) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        
        if ([pic isKindOfClass:[NSString class]]) {
            photo.photoURL = [NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:pic  ]];
        }else if([pic isKindOfClass:[UIImage class]]){
            photo.photoImage = pic;
        }
        
        [LGPhotoPickerBrowserURLArray addObject:photo];
    }
    return [LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
}

@end
