//
//  JGJWorkTypeCell.m
//  mix
//
//  Created by yj on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkTypeCell.h"
#import "UILabel+GNUtil.h"
@interface JGJWorkTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *workType;
@property (weak, nonatomic) IBOutlet UIButton *workTypeBtn;
@end

@implementation JGJWorkTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.workType.layer setLayerBorderWithColor:[UIColor whiteColor] width:1 radius:2.5];
    self.workType.layer.masksToBounds = YES;
    self.workType.backgroundColor = [UIColor whiteColor];
    self.workType.textColor = AppFont333333Color;
    self.workType.font = [UIFont systemFontOfSize:AppFont26Size];
}

- (void)setTimeModel:(JGJShowTimeModel *)timeModel {
    _timeModel = timeModel;
    [self.workTypeBtn setTitle:timeModel.timeStr forState:UIControlStateNormal];
    self.workType.text = timeModel.timeStr;
    if (timeModel.isSelected) {
       self.workType.backgroundColor = [UIColor whiteColor];
       [self.workType.layer setLayerBorderWithColor:AppFontd7252cColor width:1 radius:2.5];
        self.workType.textColor = AppFontd7252cColor;
    } else {
       self.workType.backgroundColor = AppFontf1f1f1Color;
       [self.workType.layer setLayerBorderWithColor:AppFontf1f1f1Color width:1 radius:2.5];
        self.workType.textColor = AppFont333333Color;
    }
    
    if ([timeModel.timeStr containsString:@"\n"]) {
        NSRange range = [timeModel.timeStr rangeOfString:@"\n"];
        NSString *lineStr = [timeModel.timeStr substringFromIndex:range.location + 1];
        
        self.workType.textColor = timeModel.isSelected ? AppFontd7252cColor :AppFont333333Color;
        [self.workType markLineText:lineStr withLineFont:[UIFont systemFontOfSize:AppFont24Size] withColor:timeModel.isSelected ? AppFontd7252cColor :AppFont666666Color lineSpace:3];
    }
}

- (void)setWorkTypeModel:(FHLeaderWorktype *)workTypeModel {
    _workTypeModel = workTypeModel;
    self.workType.text = workTypeModel.type_name;
    //    常规颜色显示
    self.workType.textColor = AppFont333333Color;
//    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreWorkType:)];
//    singleRecognizer.numberOfTapsRequired = 1;
//    [self.workType addGestureRecognizer:singleRecognizer];
}

- (void)setMoreCount:(NSInteger)count indexPath:(NSIndexPath *)indexPath {
    //颜色注意重用问题
    if (count == indexPath.row + 1 ) {
        self.workType.text = @"更多...";
        self.workType.textColor = AppFontd7252cColor;
        self.workType.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreWorkType:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [self.workType addGestureRecognizer:singleRecognizer];
    } else {
        self.workType.textColor = AppFont333333Color;
    }
}

- (void)loadMoreWorkType:(UITapGestureRecognizer *)singleRecognizer {
    
    if (self.blockLoadMoreWorktype) {
        self.blockLoadMoreWorktype();
    }
}

//- (IBAction)loadMoreWorkType:(UIButton *)sender {
//    
//    if (self.blockLoadMoreWorktype) {
//        self.blockLoadMoreWorktype();
//    }
//    
//    sender.selected = !sender.selected;
//    self.timeModel.isSelected = sender.selected;
//    if (self.blockSelectedtimeModel) {
//        self.blockSelectedtimeModel(self.timeModel);
//    }
//}

@end
