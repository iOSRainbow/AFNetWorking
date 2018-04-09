//
//  HttpRequestWithCache.m
//  AFNetWorking
//
//  Created by 李世飞 on 2018/4/8.
//  Copyright © 2018年 李世飞. All rights reserved.
//

#import "HttpRequestWithCache.h"
#import "AFNetworking.h"
#import "YYCache.h"
#import "MyAFHTTPSessionManager.h"
#import "NSDictionary+NullSafe.h"

NSString * const HttpCache = @"HttpRequestCache";

/**
请求方式
*/
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,//单个上传
    RequestTypeMultiUpload,//多个上传
};

@implementation HttpRequestWithCache
{
    __weak HttpRequestWithCache *weakSelf;
    NSString *tag;
}
-(instancetype)initWithDelegate:(id)requestDelegate bindTag:(NSString *)bindTag  
{
    if (self =[super init]) {
        self.requestDelegate=requestDelegate;
        self.bindTag=bindTag;
        weakSelf=self;
    }
    return self;
}

#pragma mark - Get方法(默认方法)

/**
 Get不需要进行缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpGetRequest:(NSString *)api params:(NSMutableDictionary *)params
{
    [self httpRequestWithUrlStr:api params:params requestType:RequestTypeGet isCache:NO cacheKey:nil imageKey:nil withData:nil withDataArray:nil];
}

/**
 Get需要进行缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpGetCacheRequest:(NSString *)api params:(NSMutableDictionary *)params
{
   [self httpRequestWithUrlStr:api params:params requestType:RequestTypeGet isCache:YES cacheKey:[urlStr stringByAppendingString:api] imageKey:nil withData:nil withDataArray:nil];
}

#pragma mark - Post方法
/**
 Post不需要缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpPostRequest:(NSString *)api params:(NSMutableDictionary *)params
{
    [self httpRequestWithUrlStr:api params:params requestType:RequestTypePost isCache:NO cacheKey:nil imageKey:nil withData:nil withDataArray:nil];
}

/**
 Post需要缓存
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 */
-(void)httpPostCacheRequest:(NSString *)api params:(NSMutableDictionary *)params
{
    [self httpRequestWithUrlStr:api params:params requestType:RequestTypePost isCache:YES cacheKey:[urlStr stringByAppendingString:api] imageKey:nil withData:nil withDataArray:nil];
}

#pragma mark - 上传图片方法
/**
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 imageKey：根据公司定义的如：upload
 withData: 图片NSData
 */
-(void)upLoadDataWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params imageKey:(NSString *)name withData:(NSData *)data
{
   [self httpRequestWithUrlStr:api params:params requestType:RequestTypeUpLoad isCache:NO cacheKey:[urlStr stringByAppendingString:api] imageKey:name withData:data withDataArray:nil];
}

/**
 api:接口名 如：user/login.do
 params:需要传入的参数，如果不需要可以nil
 withDataArray: 图片NSData数组
 */
-(void)upLoadDataWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params  withDataArray:(NSArray *)dataArray
{

    [self httpRequestWithUrlStr:api params:params requestType:RequestTypeMultiUpload isCache:NO cacheKey:[urlStr stringByAppendingString:api] imageKey:nil withData:nil withDataArray:dataArray];
}

#pragma mark - 网络请求统一处理
/**
 *
 *
 *  @param api         后台的接口名
 *  @param params      参数dict
 *  @param requestType 请求类型
 *  @param isCache     是否缓存标志
 *  @param cacheKey    缓存的对应key值
 *  @param name        图片上传的名字(upload)
 *  @param data        图片的二进制数据(upload)
 *  @param dataArray   多图片上传时的imageDataArray
 */
-(void)httpRequestWithUrlStr:(NSString *)api params:(NSMutableDictionary *)params requestType:(RequestType)requestType isCache:(BOOL)isCache cacheKey:(NSString *)cacheKey imageKey:(NSString *)name withData:(NSData *)data withDataArray:(NSArray *)dataArray
{
    
    NSString * url=[NSString stringWithFormat:@"%@%@",urlStr,api];;
    tag=api;//用于打印信息
    
    url=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (params==nil) {
        params=[NSMutableDictionary dictionary];
    }
    
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSLog(@"用户token=%@",token);
    token=(token==nil)?@"":token;
    
    //是否需要传入token
    if(self.isLoginFlag==1){
        
        [params setObject:token forKey:@"token"];

    }
    
    NSString *allUrl=[self urlDictToStringWithUrlStr:url WithDict:params];
    NSLog(@"\n\n 网址 \n\n      %@    \n\n 网址 \n\n 传得参数 \n\n      %@         \n\n",allUrl,params);
    
    
    //设置YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:HttpCache];
    
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
    id cacheData;
    //此处要修改为,服务端不要求重新拉取数据时执行;注意当缓存没取到时,重新访问接口
    if (isCache) {
        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheKey];
        
        if(cacheData!=nil)
        {
            //将数据统一处理
            [self returnDataWithRequestData:cacheData];
            return;
        }
    }
    
    
    AFHTTPSessionManager *session=[MyAFHTTPSessionManager sharedHTTPSession];
    

    //Get请求
    if (requestType==RequestTypeGet)
    {
        [session GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakSelf dealWithResponseObject:responseObject cacheUrl:allUrl cacheData:cacheData isCache:isCache cache:cache cacheKey:cacheKey];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"\n\n\n\n\n%@\n\n\n\n\n\n",error);
            
            [weakSelf showError:Disconnect];
        }];
    }
    else if (requestType==RequestTypePost)
    {
        [session POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakSelf dealWithResponseObject:responseObject cacheUrl:allUrl cacheData:cacheData isCache:isCache cache:cache cacheKey:cacheKey];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"\n\n\n\n\n%@\n\n\n\n\n\n",error);

            [weakSelf showError:Disconnect];
        }];

    }
    else if (requestType==RequestTypeUpLoad)
    {
        [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg",@(timeInterVal)];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpg"];
            
            //3. 图片二进制大小
            NSLog(@"Dayou upload image size= %ld k", (long)(data.length / 1024));
            
        } progress:^(NSProgress * _Nonnull uploadProgress){
      
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakSelf dealWithResponseObject:responseObject cacheUrl:allUrl cacheData:cacheData isCache:isCache cache:nil cacheKey:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"\n\n\n\n\n%@\n\n\n\n\n\n",error);

            [weakSelf showError:@"上传图片失败"];
        }];
     }
    else if (requestType==RequestTypeMultiUpload)
    {
        [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (NSInteger i = 0; i < dataArray.count; i++)
            {
                NSData *imageData = [dataArray objectAtIndex:i];
                //name和服务端约定好
                [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%zi.jpg",i] mimeType:@"image/jpg"];
                //3. 图片二进制大小
                NSLog(@"Dayou upload image size= %ld k", (long)(imageData.length / 1024));
            }
        }
            progress:^(NSProgress * _Nonnull uploadProgress) {
        
            
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [weakSelf dealWithResponseObject:responseObject cacheUrl:allUrl cacheData:cacheData isCache:isCache cache:nil cacheKey:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"\n\n\n\n\n%@\n\n\n\n\n\n",error);

            [weakSelf showError:@"上传图片失败"];
        }];
    }

}
#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData cacheUrl:(NSString *)cacheUrl cacheData:(id)cacheData isCache:(BOOL)isCache cache:(YYCache*)cache cacheKey:(NSString *)cacheKey
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
    });
    
    
    NSString * dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response\n%@\n",dataString);
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (isCache) {
        //需要缓存,就进行缓存
        [cache setObject:requestData forKey:cacheKey];
    }
   
    //不管缓不缓存都要显示数据
    [self returnDataWithRequestData:requestData];
}

#pragma mark - 根据返回的数据进行统一的格式处理-requestData 网络或者是缓存的数据-
- (void)returnDataWithRequestData:(NSData *)requestData
{
    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    
    
    //判断是否为字典
    if ([myResult isKindOfClass:[NSDictionary  class]]) {
        NSDictionary *  response = (NSDictionary *)myResult;
        
        //去除Null值
        response=[response dictionaryByReplacingNullsWithBlanks];
        
        //sucess 后台返回，我们这边是sucess=1 正确数据返回，=0返回失败
        NSInteger success =[response[@"success"] integerValue];
        NSString* message = response[@"message"]; //失败是的msg
       
        NSLog(@"tag=%@\n返回Json\n%@\n",tag,response);
        
        //返回成功
        if(success==1){
         
            [self showSuccess:response];
        
        }else
        {
          
            [self showError:message];
        }
    }

}
#pragma mark - 拼接请求的网络地址 此处是为了NSLog出传入的值，方便查看
/**
 *  拼接请求的网络地址
 *
 *  @param urlString     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlString WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlString;
    }
    
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //字符串处理
        key=[NSString stringWithFormat:@"%@",key];
        obj=[NSString stringWithFormat:@"%@",obj];
        
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        
        [parts addObject:part];
        
    }];
    
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    
    queryString = queryString.length!=0 ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",urlString,queryString];
    
    return pathStr;
    
}

#pragma mark  网络判断
-(BOOL)requestBeforeJudgeConnect
{
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        printf("Error. Count not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    return isNetworkEnable;
}

#pragma mark - 返回数据的成功显示
-(void)showSuccess:(id)response
{
    if(!self.requestDelegate) return;
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.requestDelegate respondsToSelector:@selector(Sucess:tag:)])
    {
        [self.requestDelegate performSelector:@selector(Sucess:tag:) withObject:response withObject:self.bindTag];
        return;
    }
    
    #pragma clang diagnostic pop
}

#pragma mark - 返回数据的失败显示
-(void)showError:(NSString *)error
{
    if(!self.requestDelegate) return;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wundeclared-selector"
    
    if ([self.requestDelegate respondsToSelector:@selector(Failed:tag:)])
    {
        [self.requestDelegate performSelector:@selector(Failed:tag:) withObject:error withObject:self.bindTag];
        return;
    }
    
    #pragma clang diagnostic pop
}

-(void)dealloc
{
    self.requestDelegate=nil;
}

@end
