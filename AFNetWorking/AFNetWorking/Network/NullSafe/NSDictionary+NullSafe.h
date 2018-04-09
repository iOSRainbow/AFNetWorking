//
//  NSDictionary+NullSafe.h
//  KDDBusiness
//
//  Created by 大有 on 2017/11/13.
//  Copyright © 2017年 大有. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullSafe)

- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;

@end
