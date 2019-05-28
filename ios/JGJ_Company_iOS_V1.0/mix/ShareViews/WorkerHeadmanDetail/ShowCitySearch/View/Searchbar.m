//
//
//  Searchbar.h
//  TakeCar
//
//  Created by yj on 15/11/19.
//  Copyright © 2015年 Meinekechina. All rights reserved.
//

#import "Searchbar.h"
#import "UIView+GNUtil.h"
@implementation Searchbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpBoardlayer];
    }
    return self;
    
}

+ (instancetype)searchBar {
    
    return [[self alloc] init];
    
}

- (void)setUpBoardlayer {
    self.maxLength = 20;
    self.font = [UIFont systemFontOfSize:AppFont30Size];
    self.placeholder = @"请输入城市的中文名称或拼音";
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = UITextBorderStyleNone;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search-icon"]];
    searchIcon.width = 33;
    searchIcon.height = 33;
    self.leftView = searchIcon;
    searchIcon.contentMode = UIViewContentModeCenter;
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 3;
    self.layer.borderColor = TYColorHex(0Xf3f3f3).CGColor;
    self.backgroundColor = TYColorHex(0Xf3f3f3);

}


@end
