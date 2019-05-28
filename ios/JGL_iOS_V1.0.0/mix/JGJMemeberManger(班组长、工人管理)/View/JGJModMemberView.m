//
//  JGJModMemberView.m
//  mix
//
//  Created by yj on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJModMemberView.h"

#import "TYTextField.h"

@interface JGJModMemberView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *name;

@property (weak, nonatomic) IBOutlet UIView *containNameView;

@property (weak, nonatomic) IBOutlet UIView *containInfoView;

@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation JGJModMemberView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setSubViews];
    }
    
    return self;
}

- (void)setSubViews {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    self.containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.containInfoView.layer setLayerCornerRadius:5];
    
    self.name.maxLength = 8;

    self.name.placeholder = [NSString stringWithFormat:@"请输入%@的姓名", JLGisLeaderBool ? @"工人" : @"班组长"];
    
    self.title.text = [NSString stringWithFormat:@"更改%@姓名", JLGisLeaderBool ? @"工人" : @"班组长"];
    
    self.title.font = [UIFont systemFontOfSize:AppFont34Size];
    
    self.title.textColor = AppFont666666Color;
    
    [self.containNameView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:0.5 radius:5.0];

    self.saveButton.backgroundColor = JGJMainColor;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
    
    [self.name becomeFirstResponder];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    [self modifyUsername];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissWithBlcok:nil];
}


#pragma mark - 修改用户信息
- (void)modifyUsername {
    
    if ([NSString isEmpty:self.name.text]) {
        
        NSString *warningStr = [NSString stringWithFormat:@"请输入%@姓名", JLGisLeaderBool ? @"工人" : @"班组长"];
        
        [TYShowMessage showPlaint:warningStr];
        
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"uid" : self.uid?:@"",
                                 
                                 @"comment_name" : self.name.text?:@""
                                 
                                 };
    
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
        
    [JLGHttpRequest_AFN PostWithNapi:JGJModifyCommentNameURL parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        if (weakSelf.modMemberViewBlock) {
            
            weakSelf.modMemberViewBlock(weakSelf.name.text);
        }
        
        [weakSelf dismissWithBlcok:nil];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (void)dismissWithBlcok:(void (^)(void))block {
    [UIView animateWithDuration:0.2 animations:^{
        self.containView.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self.containView) {
        
        [self dismissWithBlcok:nil];
        
    }
}

@end
