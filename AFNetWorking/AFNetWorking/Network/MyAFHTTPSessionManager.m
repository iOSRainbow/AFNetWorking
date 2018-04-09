//
//  AFHTTPSessionManager.m
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/8.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import "MyAFHTTPSessionManager.h"

@implementation MyAFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedHTTPSession
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]init];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        //设置 返回的响应对象为二进制
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval=20;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        // 验证https证书，如不需要屏蔽这块
        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"xxxx" ofType:@"cer"];
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
   
    });
    
    return manager;
}

+ (AFURLSessionManager *)sharedURLSession
{
    static AFURLSessionManager *urlsession = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        urlsession = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return urlsession;
}

@end
