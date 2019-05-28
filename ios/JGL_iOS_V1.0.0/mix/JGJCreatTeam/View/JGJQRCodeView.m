//
//  JGJQRCodeView.m
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJQRCodeView.h"
#import "TYPermission.h"
#import "JLGDashedLine.h"
#import "UIImage+TYALAssetsLib.h"
#import "UIImage+TYCreateQRCode.h"
#import "TYAvatarGroupImageView.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
//#import "JGJHeadView.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"

#import "JGJAvatarView.h"

#import "UIImage+Cut.h"

const CGFloat JGJQRCodeJoinRation = 0.75;
const CGFloat JGJQRCodeCreateRation = 0.64;

@interface JGJQRCodeView ()

@property (nonatomic , strong) UIViewController <UIActionSheetDelegate >*superVc;
//左边的圆
@property (weak, nonatomic) IBOutlet UIView *leftCircleView;

//右边的圆
@property (weak, nonatomic) IBOutlet UIView *rightCircleView;

//顶部的标题名
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

//头像
@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarImage;

@property (weak, nonatomic) IBOutlet UIView *topView;

//扫描加入需要显示的view
@property (weak, nonatomic) IBOutlet UIView *joinView;

//创建二维码需要显示的view
@property (weak, nonatomic) IBOutlet UIView *createView;

//班组长信息(创建人信息)
@property (weak, nonatomic) IBOutlet UILabel *createNameLabel;

//二维码显示的ImageView
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;

//二维码的有效时间
@property (weak, nonatomic) IBOutlet UILabel *QRCodeValidTime;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraintH;
@property (weak, nonatomic) IBOutlet UILabel *contentDetailLable;
@property (weak, nonatomic) IBOutlet UILabel *classTypeTitleLable;
@property (strong, nonatomic) UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIView *QRCodeBackView;

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeBackImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageW;

//进入的头像

@property (weak, nonatomic) IBOutlet JGJAvatarView *joinImageView;

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipBottom;

@property (weak, nonatomic) IBOutlet UILabel *myQRCodeDes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBackViewTop;


@end

@implementation JGJQRCodeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = TYColorHex(0x2e3132);
    
    [self.leftCircleView.layer setLayerBorderWithColor:TYColorHex(0xcccccc) width:1.0 ration:0.5];
    [self.rightCircleView.layer setLayerBorderWithColor:TYColorHex(0xcccccc) width:1.0 ration:0.5];

    [self.QRCodeBackView.layer setLayerCornerRadius:JGJCornerRadius / 2.0];
    
    //添加长按事件
//    UILongPressGestureRecognizer *longPresssRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    longPresssRecognizer.minimumPressDuration = 0.1;

    self.QRCodeImage.userInteractionEnabled = YES;
//    [self.QRCodeImage addGestureRecognizer:longPresssRecognizer];
    
    self.topTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.topTitleLabel.font.pointSize];
    
    self.topTitleLabel.numberOfLines = 0;
    
    [self.middleView.layer setLayerCornerRadiusWithRatio:JGJCornerRadius / 2.0];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __block BOOL isHaveDashedLine = NO;
    [self.topView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JLGDashedLine class]]) {
            isHaveDashedLine = YES;
            *stop = YES;
        }
    }];
    
    
//    CGPoint dashedLinePoint = CGPointMake(0, TYGetViewH(self.topView));
//    if (!isHaveDashedLine) {//如果没有才添加
//        //添加虚线
//        [JLGDashedLine drashHorizontalLineInView:self.topView byPoint:dashedLinePoint byWith:TYGetViewW(self.topView) lengthPattern:@[@4,@2] lineColor:TYColorHex(0xdbdbdb)];
//    }
}

- (void )setCodeViewType:(JGJQRCodeViewType)codeViewType{
    _codeViewType = codeViewType;
//    self.contentViewConstraintH.constant = (codeViewType == JGJQRCodeViewCreate?JGJQRCodeCreateRation:JGJQRCodeJoinRation)*TYGetUIScreenHeight;
//
//    //iPhone5和4的高度要对应变
//    if (TYIS_IPHONE_5_OR_LESS && codeViewType == JGJQRCodeViewJoin) {
//        self.contentViewConstraintH.constant *= 0.9;
//    }
    
    self.myQRCodeDes.hidden = YES;
    
    self.joinView.hidden = codeViewType == JGJQRCodeViewCreate;
    self.createView.hidden = !(codeViewType == JGJQRCodeViewCreate);
    
    self.contentView.backgroundColor =  codeViewType == JGJQRCodeViewCreate ? TYColorHex(0x2e3132) : [UIColor whiteColor];

    [self.avatarImage getRectImgView:self.proListModel.members_head_pic];
    
    NSString *proName = @"";
    
    if (![NSString isEmpty:self.proListModel.group_full_name] && [self.proListModel.class_type isEqualToString:@"group"]) {
        
        self.topTitleLabel.text = self.proListModel.group_full_name;
        
    }else {

        proName = [NSString stringWithFormat:@"%@",self.proListModel.group_name];
        
//        if (![NSString isEmpty:self.proListModel.group_name] && [self.proListModel.class_type isEqualToString:@"group"]) {
//
//            proName = [NSString stringWithFormat:@"%@",self.proListModel.group_name];
//
//        }else if (![NSString isEmpty:self.proListModel.pro_name] && ![NSString isEmpty:self.proListModel.group_name]) {
//
//            if ([self.proListModel.pro_name isEqualToString:self.proListModel.group_name]) {
//
//                proName = [NSString stringWithFormat:@"%@", self.proListModel.group_name];
//
//            }
//
//        }
    
        self.topTitleLabel.text = proName;
    }
    
    NSString *lineText = @"";
    
    if ([self.proListModel.class_type isEqualToString:@"team"]) {
        [self.avatarImage getRectImgView:self.proListModel.members_head_pic];

        self.contentDetailLable.text = @"使用吉工家APP扫描以上二维码，\n即可加入此项目组";
        lineText = @"即可加入此项目组";
        
    } else if ([self.proListModel.class_type isEqualToString:@"group"]) {
        [self.avatarImage getRectImgView:self.proListModel.members_head_pic];

        self.contentDetailLable.text = @"使用吉工家APP扫描以上二维码，\n即可加入此班组";
        lineText = @"即可加入此班组";
    }else if ([self.proListModel.class_type isEqualToString:@"groupChat"]) {
       [self.avatarImage getRectImgView:self.proListModel.members_head_pic];


        self.contentDetailLable.text = @"使用吉工家APP扫描以上二维码，\n即可加入此群";
    }else if ([self.proListModel.class_type isEqualToString:@"addFriend"]) {
    
        UIColor *backGroundColor = [NSString modelBackGroundColor:self.proListModel.group_name];
        
        NSString *headPicPath = @"";
        if (self.proListModel.members_head_pic.count > 0) {
            
            headPicPath = [self.proListModel.members_head_pic lastObject];
        }
        
        self.headButton = [UIButton new];
        [self.avatarImage addSubview:self.headButton];
        [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(self.avatarImage);
        }];
        
        [self.headButton setMemberPicButtonWithHeadPicStr:headPicPath memberName:self.proListModel.group_name memberPicBackColor:backGroundColor];
        
        NSString *des = @"使用吉工家APP扫描以下二维码，\n即可加我为朋友";
        
        self.contentDetailLable.text = des;
        
        self.contentDetailLable.hidden = YES;
        
        self.contentBackViewTop.constant = 60;
        
        self.myQRCodeDes.text = des;
        
        self.myQRCodeDes.hidden = NO;
        
        lineText = @"即可加我为朋友";
        
        [self.myQRCodeDes markLineText:lineText withLineFont:[UIFont systemFontOfSize:AppFont26Size] withColor:AppFont666666Color lineSpace:4];
        
    }
    NSString *nameType = nil;
    if (codeViewType == JGJQRCodeViewJoin) {//创建
        if ([self.proListModel.class_type isEqualToString:@"team"]) {
            self.classTypeTitleLable.text = @"项目信息";
            nameType = @"管理员";
            self.createNameLabel.text = [NSString stringWithFormat:@"%@:%@", nameType, self.proListModel.creater_name];
        } else if ([self.proListModel.class_type isEqualToString:@"group"]) {
            self.classTypeTitleLable.text = @"班组信息";
            nameType = @"班组长/工头";
            self.createNameLabel.text = [NSString stringWithFormat:@"%@:%@", nameType, self.proListModel.creater_name];
        }else if ([self.proListModel.class_type isEqualToString:@"groupChat"]) {
            nameType = @"群聊信息";
            self.classTypeTitleLable.text = [NSString stringWithFormat:@"%@ 成员: %@人", nameType, self.proListModel.members_num];
            self.createNameLabel.text = @"";
            [self.classTypeTitleLable markText:nameType withColor:AppFont333333Color];
        }

    }
    
    self.QRCodeBackImageView.hidden = ![self.proListModel.class_type isEqualToString:@"addFriend"];
    
    if (![self.proListModel.class_type isEqualToString:@"addFriend"]) {
        
        self.QRCodeImageW.constant = JGJQRCodeCreateRation * TYGetUIScreenWidth;
        
        self.tipBottom.constant = TYIS_IPHONE_5 ? 23 : 43;
        
    }else {
        
        self.tipBottom.constant = 8;
    }
    
    self.avatarImage.hidden = NO;
    
    self.joinImageView.hidden = YES;
    
    self.topTitleLabel.hidden = NO;
    
    if (_codeViewType == JGJQRCodeViewJoin) {
        
        self.avatarImage.hidden = YES;
        
        self.joinImageView.hidden = NO;
        
        self.topTitleLabel.hidden = YES;

        [self.joinImageView getRectImgView:self.proListModel.members_head_pic];
        
        self.createNameLabel.text = self.proListModel.group_name;
        
        NSString *classtypeDes = @"";
        if ([self.proListModel.class_type isEqualToString:@"team"]) {
            
            classtypeDes = @"项目";
            
        }else if ([self.proListModel.class_type isEqualToString:@"group"]) {
            
            classtypeDes = @"班组";
            
            //自己在设置拼接班组名字
            if (![NSString isEmpty:self.proListModel.group_full_name]) {
                
                self.createNameLabel.text = self.proListModel.group_full_name;
                
            }else {
                
                if (![NSString isEmpty:self.proListModel.pro_name]) {
                    
                    proName = [NSString stringWithFormat:@"%@-",self.proListModel.pro_name];
                }
                
                self.createNameLabel.text = [NSString stringWithFormat:@"%@%@", proName,self.proListModel.group_name];
            }
            
        }
        
        self.classTypeTitleLable.text = [NSString stringWithFormat:@"%@创建者：%@", classtypeDes, self.proListModel.creater_name];
    }
    
    int random = 1 + arc4random() % 4;
    
    NSString *randomImageStr = [NSString stringWithFormat:@"QRCode_Back_0%@", @(random)];
    
    self.QRCodeBackImageView.image = [UIImage imageNamed:randomImageStr];
    
    [self.contentDetailLable markLineText:lineText withLineFont:[UIFont systemFontOfSize:AppFont26Size] withColor:AppFont666666Color lineSpace:4];

    
    [self layoutIfNeeded];
    
}

- (void)createQRCodeImageWithUrl:(NSString *)codeUrl{
    
    self.QRCodeImage.image = [UIImage imageOfQRFromURL:codeUrl];
    
    CGFloat QRCodeImageWRation = 0.3;
    
    CGFloat QRCodeImageW = QRCodeImageWRation * TYGetUIScreenWidth;
    
    if (![self.proListModel.class_type isEqualToString:@"addFriend"]) {

        self.QRCodeImageW.constant = QRCodeImageWRation * TYGetUIScreenWidth;

        QRCodeImageW = JGJQRCodeCreateRation * TYGetUIScreenWidth;;

    }

}

- (void)superVc:(UIViewController <UIActionSheetDelegate >*)superVc{
    self.superVc = superVc;
}

#pragma mark - 长按处理的事件
- (void)longPress:(UILongPressGestureRecognizer *)press {
    switch (press.state) {
        case UIGestureRecognizerStateBegan: {
            if ([TYPermission isCanPhotoWithStr:@"请在允许浏览相册"]) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              
                                              initWithTitle:@"保存图片"
                                              
                                              delegate:self.superVc
                                              
                                              cancelButtonTitle:@"取消"
                                              
                                              destructiveButtonTitle:nil
                                              
                                              otherButtonTitles:@"保存图片到手机",nil];
                
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                
                [actionSheet showInView:self.superVc.view];
            }
            break;
        }
        default: {
            break;
        }
    }
}

- (void)saveToAlbum{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//        
//        [self.QRCodeImage.image saveToAlbum:appName completionBlock:^{
//            [TYShowMessage showSuccess:@"保存图片成功"];
//        } failureBlock:^(NSError *error) {
//            [TYShowMessage showError:@"保存图片失败"];
//        }];
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self saveImage];
    });
    
}


- (void)saveImage
{
    [UIImage saveScreenShotWithView:self offsetY:0 isSavePhoto:YES];
    
    return;
    
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, [self center].x, [self center].y);
        CGContextConcatCTM(context, [self transform]);
        CGContextTranslateCTM(context, -[self bounds].size.width*[[self layer] anchorPoint].x, -[self bounds].size.height*[[self layer] anchorPoint].y);
        [[self layer] renderInContext:context];
        
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    if (image)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            
            [image saveToAlbum:appName completionBlock:^{
                [TYShowMessage showSuccess:@"已保存到手机相册"];
            } failureBlock:^(NSError *error) {
                [TYShowMessage showError:@"保存图片失败"];
            }];
        });
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        [TYShowMessage showSuccess:@"保存失败"];
        
    } else {
        
        [TYShowMessage showSuccess:@"成功保存到相册"];
    }
}

@end
