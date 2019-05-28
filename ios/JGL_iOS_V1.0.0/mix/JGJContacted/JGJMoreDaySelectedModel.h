//
//  JGJMoreDaySelectedModel.h
//  mix
//
//  Created by Tony on 2019/2/19.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJMoreDaySelectedModel : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDate *date;

@end
