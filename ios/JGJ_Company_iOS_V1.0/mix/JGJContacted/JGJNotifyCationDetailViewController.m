//
//  JGJNotifyCationDetailViewController.m
//  mix
//
//  Created by Tony on 2016/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotifyCationDetailViewController.h"
#import "JGJNotiFicationView.h"
#import "JGJNotificationDetailTableViewCell.h"
#import "JGJBottomButton.h"
#import "JGJGetViewFrame.h"
#import "UIImageView+WebCache.h"
#import "JGJTOPHeadview.h"
#import "TYInputView.h"

#define MainScreen    [UIScreen mainScreen].bounds.size
#define leftalign     NSTextAlignmentLeft
#define rightalign    NSTextAlignmentRight
#define centeralign   NSTextAlignmentCenter
static NSString *cellIndentifer = @"MyCellIndentifer";

@interface JGJNotifyCationDetailViewController ()<UITableViewDelegate ,UITableViewDataSource,UITextViewDelegate>
{
    // headerView 的显示图片的view
    UIImageView *HeadImageView;
    NSMutableArray *DataArray;
    NSMutableArray *ReciveArray;
    NSString *Nowmsg_id;
    UIView *backview;
    float height;
    UIView *topView;
    JGJNotificationDetailTableViewCell *cell;
}
@property(nonatomic ,strong)JGJNotiFicationView *NewsDetailView;
@property(nonatomic ,strong)UITableView *detailTableview;
@property(nonatomic ,assign)CGFloat textFieldOldHeight;

@property(nonatomic ,strong)UITextView *TextView;

@end

@implementation JGJNotifyCationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
      [self initInterFace];

}
-(void)initInterFace{
    [self.view addSubview:self.detailTableview];
}
-(void)InitReplyButton
{
    JGJBottomButton *botton = [[JGJBottomButton alloc]initWithFrame:CGRectMake(0, MainScreen.height-50, MainScreen.width, 50)];
    [self.view addSubview:botton];
}
-(JGJNotiFicationView *)NewsDetailView
{
    if (!_NewsDetailView) {
        _NewsDetailView = [[JGJNotiFicationView alloc]initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width-10, 300)];
        _NewsDetailView.backgroundColor = [UIColor clearColor];
    }
    
    return _NewsDetailView;
    
}
-(UITableView *)detailTableview
{
    if (!_detailTableview) {
        _detailTableview = [UITableView new];
        [_detailTableview setFrame:CGRectMake(0, 0, MainScreen.width, MainScreen.height-110)];
        _detailTableview.dataSource =self;
        _detailTableview.delegate = self;
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"NotificationDeatail" owner:self options:nil]firstObject];
        [view setFrame:CGRectMake(0, 0, MainScreen.width, 350)];
        [view addSubview:self.NewsDetailView];
        _detailTableview.tableHeaderView = view;
        _detailTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _detailTableview.separatorStyle = NO;
    }
    return _detailTableview;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[JGJNotificationDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        
        cell.DataArray = DataArray[indexPath.row];

    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return DataArray.count;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    return  [cell getheight];
    
}
-(void)setJgjChatListModel:(JGJChatMsgListModel *)jgjChatListModel
{

    _jgjChatListModel = jgjChatListModel;
    _NewsDetailView = [JGJNotiFicationView new];
    _NewsDetailView.DetailModel = jgjChatListModel;
    Nowmsg_id = jgjChatListModel.msg_id;
    [self HadRecivemasgID:jgjChatListModel.msg_id];
    
    JGJTOPHeadview *top = [[JGJTOPHeadview alloc]init];
    top.listModel = jgjChatListModel;
    
}
#pragma mark - 获取回复列表
-(void)HadRecivemasgID:(NSString *)msg_id{
    
    
    NSDictionary *body = @{
                           @"ctrl" : @"Team",
                           @"action": @"getReplyList",
                           @"msg_id":msg_id
                           };
    [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
        DataArray = [NSMutableArray array];
        DataArray = responseObject[@"replyList"];
        _NewsDetailView.HadreciveArray = responseObject[@"members"];
        [_detailTableview reloadData];
    } failure:^(NSError *error, id values) {
        
    } showHub:NO];
}
#pragma mark - 点击回复
- (IBAction)ClickReplyButton:(id)sender {
    [self InitTextView];
//    [self GetNetDatamasgID:Nowmsg_id Action:@"replyMessage"];
}
#pragma mark -点击收到
- (IBAction)ClickHadReciveButton:(id)sender {
    [self GetNetDatamasgID:Nowmsg_id Action:@"requestMessage"];
}

-(void)GetNetDatamasgID:(NSString *)msg_id Action:(NSString *)actionType{
        NSDictionary *body= @{
                                   @"msg_id":msg_id,
                                   @"reply_text":_TextView.text
                                   };
    [JLGHttpRequest_AFN PostWithApi:@"/v2/task/taskReply" parameters:body success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    }];
//    NSDictionary *body;
//    if ([actionType isEqualToString:@"replyMessage"]) {
//        body = @{
//                               @"ctrl" : @"Team",
//                               @"action": actionType,
//                               @"msg_id":msg_id,
//                               @"reply_text":_TextView.text
//                               };
//        
//        [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
//            DataArray = [NSMutableArray array];
//            DataArray = responseObject;
//            [_detailTableview reloadData];
//        } failure:^(NSError *error, id values) {
//            
//        } showHub:NO];
//        
// 
//    }else{
//    body = @{
//                           @"ctrl" : @"Team",
//                           @"action": actionType,
//                           @"msg_id":msg_id
//                           };
//        [JGJSocketRequest WebSocketWithParameters:body success:^(id responseObject) {
//            _NewsDetailView.HadreciveArray = responseObject;
//            
//        } failure:^(NSError *error, id values) {
//            
//        } showHub:NO];
//        
//
//    }
    
    
}
-(void)InitTextView
{

    [self initEditeView];

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]||[text isEqualToString:@"Effigy"]){
        [textView resignFirstResponder];
        [self EditeTextView];


        return NO;
    }
    
    return YES;
}

-(void)initEditeView
{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreen.height-105, MainScreen.width, 40)];
    topView.backgroundColor = [UIColor darkGrayColor];
    _TextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, MainScreen.width-80, 30)];
    _TextView.returnKeyType = UIReturnKeySend;
    _TextView.delegate = self;
    _TextView.layer.masksToBounds = YES;
    _TextView.layer.cornerRadius = 4;
    _TextView.layer.borderWidth = 1;
    _TextView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _TextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView addSubview:self.TextView];
    
    [_TextView becomeFirstResponder];
    

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake([JGJGetViewFrame GetMaxX:_TextView]+10, 5, 60, 30)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6;
    [button addTarget:self action:@selector(sendReplay) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"回复" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [topView addSubview:button];

}
-(void)sendReplay
{
    [self EditeTextView];


}
-(void)EditeTextView{
    
    [self GetNetDatamasgID:Nowmsg_id Action:@"replyMessage"];
    [_TextView resignFirstResponder];
    [topView removeFromSuperview];



}
@end
