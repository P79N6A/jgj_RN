//
//  JGJMemberMangerModel.h
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    JGJMemberImpressSelTagViewType, //选择标签
    
    JGJMemberImpressShowTagViewType, //显示标签
    
    JGJMemberImpressComselTagViewType, //常用选中标签
    
    JGJMemberImpressRemarkselTagViewType, //记工筛选备注选中标签
    
    JGJMemberImpressAgencyselTagViewType, //记工筛代理人选中标签
    
} JGJMemberImpressTagViewType;

@interface JGJMemberImpressTagViewModel : NSObject

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSArray *tagModels;

@property (nonatomic, copy) NSString *tag_name;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, assign) BOOL selected;

//标签宽度
@property (nonatomic, assign) CGFloat tagNameW;

//用于标签显示类型
@property (nonatomic ,assign) JGJMemberImpressTagViewType tagViewType;

@end

@interface JGJMemberAppraiseStarsModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *score;

//禁止滑动改变分数
@property (nonatomic, assign) BOOL isForbidTouch;

//星星高度
@property (nonatomic, assign) CGFloat height;

@end

@interface JGJMemberMangerModel : NSObject

@property (nonatomic, strong) NSArray *tag_names;

//标签模型
@property (nonatomic, strong) NSArray *tagModels;

@property (nonatomic, assign) CGFloat tagViewHeight;

@property (nonatomic, strong) NSString *reliance_degree;

@property (nonatomic, strong) NSString *attitude_or_arrears;

@property (nonatomic, strong) NSString *professional_or_abuse;

@property (nonatomic, strong) NSString *want_cooperation_rate;

//是否存在记账数据
@property (nonatomic, assign) BOOL isExistRecordData;

//是否存在星星评论
@property (nonatomic, assign) BOOL isExistStar;

@property (nonatomic, strong) JGJRecordWorkStaListModel *bill_info;

@property (nonatomic, strong) NSArray *starsScores;

//是否能评价
@property (nonatomic, assign) BOOL can_evaluate;

//评价数量
@property (nonatomic, assign) NSString *evaluate_num;

//不能评价的消息
@property (nonatomic, copy) NSString *can_not_msg;

//标签模型
@property (nonatomic, strong) NSMutableArray <JGJMemberImpressTagViewModel *>*tag_list;

@property (nonatomic, assign) JGJMemberImpressTagViewType tagViewType;

//评价人数
@property (nonatomic, copy) NSString *evaluate_pnum;

//愿意雇佣人数
@property (nonatomic, copy) NSString *want_pnum;

//评论的图片
@property (nonatomic, strong) NSMutableArray *notes_img;

//评论的文字
@property (nonatomic, copy) NSString *notes_txt;

//备注文字高度
@property (nonatomic, assign) CGFloat notes_txt_H;

//备注图片高度
@property (nonatomic, assign) CGFloat notes_img_H;

//总高度
@property (nonatomic, assign) CGFloat notes_H;

@end

@class JGJMemberImpressTagView;

@interface JGJMemberEvaListModel : NSObject

@property (nonatomic, copy) NSString *pub_date;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) JGJSynBillingModel *user_info;

//标签模型
@property (nonatomic, strong) NSMutableArray <JGJMemberImpressTagViewModel *>*tag_list;

@property (nonatomic, strong) NSString *reliance_degree;

@property (nonatomic, strong) NSString *attitude_or_arrears;

@property (nonatomic, strong) NSString *professional_or_abuse;

@property (nonatomic, strong) NSArray <JGJMemberAppraiseStarsModel *>*scores;

//标签高度
@property (nonatomic, assign) CGFloat tagHeight;

//整体高度
@property (nonatomic, assign) CGFloat cellHeight;

//标签视图
@property (nonatomic, strong) JGJMemberImpressTagView *tagView;

@property (nonatomic, strong) NSMutableAttributedString *attContentStr;
//是否是最近的评级
@property (nonatomic, assign) BOOL is_near_eva;

@end

@interface JGJMemberEvaluateInfoModel : NSObject

@property (nonatomic, copy) NSString *cooperation_pro_num;

@property (nonatomic, copy) NSString *total_work_hours;

@property (nonatomic, strong) NSMutableArray <JGJMemberImpressTagViewModel *> *tag_list;

/** 合作项目情况 */
@property (nonatomic, strong) NSArray *cooProInfos;

/** 标签高度 */
@property (nonatomic, assign) CGFloat tagViewHeight;

@end

//检测对账是否开启

@interface JGJWorkdayGetRecordConfirmOffStatusModel : NSObject

@property (nonatomic, copy) NSString *status;

@end
