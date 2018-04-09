//
//  Api.h
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/9.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestWithCache.h"



@interface Api : NSObject

@property (nonatomic,strong)  HttpRequestWithCache *httpRequest;

-(instancetype)init:(id)delegate tag:(NSString *)tag;


#pragma mark 接口管理

/**
 一下测试接口名称，随意写的，只是做一个参考
*/


//获取商品信息
-(void)getGoodInfo:(NSString*)goodId;


//修改用户昵称
-(void)ModfiyUsername:(NSString*)username;


@end
