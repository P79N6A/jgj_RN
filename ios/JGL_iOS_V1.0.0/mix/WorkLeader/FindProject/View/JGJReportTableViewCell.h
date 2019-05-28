//
//  JGJReportTableViewCell.h
//  mix
//
//  Created by Tony on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYmodel.h"

typedef NS_ENUM(NSUInteger, JGJReportType) {
    JGJReportTypeNormal = 0,
    JGJReportTypeOther//其他
};

@class JGJReportModel,JGJReportTableViewCell;

@protocol JGJReportTableViewCellDelegate <NSObject>
- (void)JGJReportTextChange:(JGJReportTableViewCell *)reportCell textString:(NSString *)textString;
@end

@interface JGJReportTableViewCell : UITableViewCell

@property (nonatomic,assign) JGJReportType reportType;
@property (weak, nonatomic) IBOutlet UITextView *otherDescTextView;
@property (nonatomic , weak) id<JGJReportTableViewCellDelegate> delegate;

- (void)setReportType:(JGJReportType)reportType setReportModel:(JGJReportModel *)reportModel;
@end

@interface JGJReportModel : TYModel
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *desc;
@property (copy,nonatomic) NSString *code;
@property (assign,nonatomic) BOOL selected;
@end
