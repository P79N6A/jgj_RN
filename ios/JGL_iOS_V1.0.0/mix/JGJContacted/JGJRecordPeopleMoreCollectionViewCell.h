//
//  JGJRecordPeopleMoreCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/9/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJRecordPeopleMoreCollectionViewDelegate <NSObject>

- (void)JGJLongPressMoreCollectionAndIndexPath:(NSIndexPath *)indexpath;//长按某一个人编辑薪资模板

@end

@interface JGJRecordPeopleMoreCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *baseView;

@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@property (strong, nonatomic) IBOutlet UILabel *nameLable;

@property (nonatomic ,strong)JgjRecordMorePeoplelistModel *listModel;

@property (strong, nonatomic) IBOutlet UIButton *headButton;
@property (strong, nonatomic) IBOutlet UIImageView *noTPLImageView;

@property (strong, nonatomic) IBOutlet UIImageView *slectImageView;

@property (nonatomic ,strong)id <JGJRecordPeopleMoreCollectionViewDelegate> delegate;

@property (nonatomic, strong)NSIndexPath *indexpath;


- (void)setListModelAddIsLittleWork:(JgjRecordMorePeoplelistModel *)listModel isLittleWorkOrContractorAttendance:(BOOL)isLittleWorkOrContractorAttendance;

-(void)setAddButton;
- (void)setDelButton;
-(void)loadView;
@end
