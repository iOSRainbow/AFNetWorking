//
//  NSDictionary+NullSafe.m
//  KDDBusiness
//
//  Created by 大有 on 2017/11/13.
//  Copyright © 2017年 大有. All rights reserved.
//

#import "NSDictionary+NullSafe.h"
#import "NSArray+NullSafe.h"

@implementation NSDictionary (NullSafe)


- (NSDictionary *)dictionaryByReplacingNullsWithBlanks
{
    NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object == nul) [replaced setObject:blank forKey:key];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        else if ([object isKindOfClass:[NSArray class]]) [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
    }
    return replaced;
}

@end
