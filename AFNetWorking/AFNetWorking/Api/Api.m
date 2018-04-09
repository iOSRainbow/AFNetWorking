//
//  Api.m
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/9.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import "Api.h"

@implementation Api

#define isLoginFlag httpRequest.isLoginFlag  //是否需要token

@synthesize httpRequest;


-(instancetype)init:(id)delegate tag:(NSString *)tag
{
    if (self=[super init]) {
        httpRequest=[[HttpRequestWithCache alloc]initWithDelegate:delegate bindTag:tag];
    }
    return self;
}



//获取商品信息
-(void)getGoodInfo:(NSString*)goodId{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params setObject:goodId forKey:@"id"];
    [httpRequest httpPostRequest:@"goods/info.do" params:params];
}


//修改用户昵称
-(void)ModfiyUsername:(NSString*)username{
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params setObject:username forKey:@"username"];
    [httpRequest httpPostRequest:@"user/modfiy/username.do" params:params];
}
@end
