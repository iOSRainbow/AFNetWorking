//
//  NSArray+NullSafe.m
//  KDDBusiness
//
//  Created by 大有 on 2017/11/13.
//  Copyright © 2017年 大有. All rights reserved.
//

#import "NSArray+NullSafe.h"
#import "NSDictionary+NullSafe.h"

@implementation NSArray (NullSafe)

- (NSArray *)arrayByReplacingNullsWithBlanks  {
    NSMutableArray *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (int idx = 0; idx < [replaced count]; idx++) {
        id object = [replaced objectAtIndex:idx];
        if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithBlanks]];
        else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
    }
    return replaced;
}

@end
