//
//  HttpRequestWithCache.h
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/8.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import <Foundation/Foundation.h>


#define urlStr @"https:www.baidu.com/app/"  //这边随意写的，到时候换成公司的
#define Disconnect @"网络连接超时，请检查网络设置"

@protocol HttpRequestCacheDelegate <NSObject>

@optional


@end

@interface HttpRequestWithCache : NSObject

-(instancetype)initWithDelegate:(id)requestDelegate bindTag:(NSString *)bindTag;

@property (nonatomic,strong)  id requestDelegate;


/**
 接口参数名，一个界面过多接口时，用来区分接口返回
*/
@property (nonatomic,copy)  NSString *bindTag;


/**
 是否需要token
 */
@property(nonatomic,assign)NSInteger isLoginFlag;

#pragma mark - Get方法(默认方法)
/**
 Get不需要进行缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
*/
-(void)httpGetRequest:(NSString *)api params:(NSMutableDictionary *)params;

/**
 Get需要进行缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpGetCacheRequest:(NSString *)api params:(NSMutableDictionary *)params;


#pragma mark - Post方法
/**
 Post不需要缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpPostRequest:(NSString *)api params:(NSMutableDictionary *)params;

/**
 Post需要缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpPostCacheRequest:(NSString *)api params:(NSMutableDictionary *)params;



#pragma mark - 上传图片方法
/**
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 imageKey：根据公司定义的如：upload
 withData: 图片NSData
 */
-(void)upLoadDataWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params imageKey:(NSString *)name withData:(NSData *)data;

/**
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 withDataArray: 图片NSData数组
 */
-(void)upLoadDataWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params  withDataArray:(NSArray *)dataArray;



@end
