//
//  JGJNoDataDefultView.m
//  JGJCompany
//
//  Created by Tony on 2017/11/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJNoDataDefultView.h"

@implementation JGJNoDataDefultView

-(instancetype)initWithFrame:(CGRect)frame  andSuperView:(UIView *)view andModel:(JGJNodataDefultModel *)model helpBtnBlock:(clickHelpBtnBlock)helpBlock pubBtnBlock:(clickpubBtnBlock)pubBlock {

    if (self = [super initWithFrame:frame]) {
        
        self.helpBlock = helpBlock;
        
        self.pubBlock = pubBlock;
        
        [self loadView];

        self.contentLbale.text = model.contentStr?:@"";
        
        [self.helpButton setTitle:model.helpTitle?:@"" forState:UIControlStateNormal];
        
        [self.pubButton setTitle:model.pubTitle?:@"" forState:UIControlStateNormal];
        [view addSubview:self];

    }
    
    return self;
}
-(void)setDefultModel:(JGJNodataDefultModel *)defultModel
{
    _defultModel = defultModel;
    self.contentLbale.text = defultModel.contentStr?:@"";
    [self.helpButton setTitle:defultModel.helpTitle?:@"" forState:UIControlStateNormal];
    [self.pubButton setTitle:defultModel.pubTitle?:@"" forState:UIControlStateNormal];


}
-(void)loadView{

    UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"JGJNoDataDefultView" owner:self options:nil]firstObject];
       self.helpButton.layer.masksToBounds = YES;
    self.helpButton.layer.cornerRadius = 5;
    self.helpButton.layer.borderWidth = 0.5;
    self.helpButton.layer.borderColor = AppFont666666Color.CGColor;
    
    self.pubButton.layer.masksToBounds = YES;
    self.pubButton.layer.cornerRadius = 5;
    [view setFrame:CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetHeight(self.frame))];
    [self addSubview:view];

}
- (IBAction)clickHelpBtn:(id)sender {
    self.helpBlock(self.defultModel.helpTitle);
}
- (IBAction)clickPubBtn:(id)sender {
    self.pubBlock(self.defultModel.pubTitle);
}

@end
