//
//  JGJRecordStaDownLoadVc.m
//  mix
//
//  Created by yj on 2019/2/19.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRecordStaDownLoadVc.h"

#import "JGJRecordTool.h"

#import "JGJKonwRepoWebViewVc.h"

@interface JGJRecordStaDownLoadVc ()<UIDocumentInteractionControllerDelegate> {
    
    UIDocumentInteractionController *_documentInteraction;
}

@property (weak, nonatomic) IBOutlet UILabel *fileName;


@end

@implementation JGJRecordStaDownLoadVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fileName.text = self.downLoadModel.file_name;
    
    self.title = @"下载";
}



- (IBAction)shareBtnPressed:(UIButton *)sender {
    
    [self shareRecordForm];
    
}

//下载并打开

- (IBAction)downloadBtnPressed:(UIButton *)sender {
    
    JGJRecordTool *tool = [self recordTool:YES];
    
    TYWeakSelf(self);
    
    tool.recordToolBlock = ^(BOOL isSucess, NSURL *localFilePath) {
        
        [weakself openDocument:localFilePath];
        
        
    };
    
}

- (void)openDocument:(NSURL *)filePathURL {
    
    JGJKnowBaseModel *knowBaseModel = [[JGJKnowBaseModel alloc] init];
    
    knowBaseModel.localFilePathURL = filePathURL;
    
    knowBaseModel.file_name = self.downLoadModel.file_name;
    
    knowBaseModel.file_type = self.downLoadModel.file_type;
    
    JGJKonwRepoWebViewVc *webViewVc = [[JGJKonwRepoWebViewVc alloc] init];
    
    webViewVc.title = knowBaseModel.file_name;
    
    webViewVc.knowBaseModel = knowBaseModel;
    
    webViewVc.isHiddenBottomBtn = YES;
    
    [self.navigationController pushViewController:webViewVc animated:YES];
}

#pragma mark - 分享账单表格
- (void)shareRecordForm {
    
    JGJRecordTool *tool = [self recordTool:NO];
    
    TYWeakSelf(self);
    
    tool.recordToolBlock = ^(BOOL isSucess, NSURL *localFilePath) {
        
        [weakself shareFormWithFileUrl:localFilePath];
        
    };
    
}

- (JGJRecordTool *)recordTool:(BOOL)isOpenDocument {
    
    JGJRecordTool *tool = [[JGJRecordTool alloc] init];
    
    JGJRecordToolModel *toolModel = [JGJRecordToolModel new];
    
    toolModel.url = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP, self.downLoadModel.file_path];
    
    toolModel.type = self.downLoadModel.file_type?:@"";
    
    toolModel.name = self.downLoadModel.file_name?:@"";
    
    toolModel.curVc = self;
    
    toolModel.isOpenDocument = isOpenDocument;
    
    tool.toolModel = toolModel;
    
    return tool;
}

- (void)shareFormWithFileUrl:(NSURL *)fileUrl {
    
    _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
    
    _documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
    
    [_documentInteraction presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    _documentInteraction = nil;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
