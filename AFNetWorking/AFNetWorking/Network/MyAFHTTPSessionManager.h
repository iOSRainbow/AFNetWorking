//
//  AFHTTPSessionManager.h
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/8.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface MyAFHTTPSessionManager : NSObject

+ (AFHTTPSessionManager *)sharedHTTPSession;
+ (AFURLSessionManager *)sharedURLSession;

@end
