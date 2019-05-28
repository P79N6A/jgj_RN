//
//  UITableViewCell+Extend.m
//  Carpenter
//
//  Created by 冯成林 on 15/4/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "UITableViewCell+Extend.h"
#import "UIView+Extend.h"

@implementation UITableViewCell (Extend)

+ (UITableViewCell *)getNilViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifierID = @"UITableViewNilCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifierID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

+ (void)registerNib:(UITableView *)tableView estimateRowHeight:(CGFloat )esRowHeight protoTypeCell:(UITableViewCell *)protoTypeCell{
    NSString *identifierStr = NSStringFromClass([self class]);
    
    UINib *cellNib = [UINib nibWithNibName:identifierStr bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:identifierStr];
    
    tableView.estimatedRowHeight = esRowHeight;
    protoTypeCell  = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    protoTypeCell.translatesAutoresizingMaskIntoConstraints = NO;
}

/**
 *  创建cell
 *
 *  @param tableView 所属tableView
 *
 *  @return cell实例
 */
+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *MyIdentifierID = NSStringFromClass([self class]);
    
    //从缓存池中取出cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifierID];

    //缓存池中无数据
    if(cell == nil){
        cell = [self viewFromXIB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

+(instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    
    NSString *MyIdentifierID = NSStringFromClass([self class]);
    
    //从缓存池中取出cell
// 以前   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifierID forIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    //缓存池中无数据
    if(cell == nil){
        cell = [self viewFromXIB];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

+ (instancetype)cellWithTableViewNotXib:(UITableView *)tableView {
    
    NSString *MyIdentifierID = NSStringFromClass([self class]);
    
    //从缓存池中取出cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
    
    //缓存池中无数据
    if(cell == nil){
        
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifierID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB{
    
    NSString *name = NSStringFromClass(self);
    
    UITableViewCell *xibView = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] firstObject];
    
    if(xibView == nil){
        TYLog(@"CoreXibView：从xib创建视图失败，当前类是：%@",name);
    }
    
    return xibView;
}

@end
