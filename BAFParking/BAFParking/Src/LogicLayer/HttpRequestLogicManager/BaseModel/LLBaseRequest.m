//
//  LLBaseRequest.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "LLBaseRequest.h"
#import "LLErrorOfRequest.h"
#import "NSString+URL.h"
#import "NLReqestMessage.h"
#import "NLHttpClientModel.h"

@implementation LLBaseRequest
//请求参数拼接
- (NSString*)getReqUrl:(NSString*)url
            parameters:(NSDictionary*)parameters
{
    NSDictionary *paramDict = [self fullParamFromDictionary:parameters];
    return [NSString mm_URLString:url fromDictionary:paramDict];
}

#pragma mark-- 私有API
//获取公共参数
- (NSDictionary*)getCommonParameter
{
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
    // 拼接通用字段
    //    [mDict setObject:@"ios" forKey:@"platform"];
    //    [mDict setObject:kAppVersion forKey:@"app_version"];
    //    [mDict setObject:[OpenUDID value] forKey:@"device_token"];
    //    [mDict setObject:[NSString stringWithFormat:@"%0.2f",[[[UIDevice currentDevice] systemVersion] floatValue]] forKey:@"platform_version"];
    //    if (GlobalInstance.accessToken) {
    //        [mDict setObject:GlobalInstance.accessToken forKey:@"access_token"];
    //    }
    //    else
    //    {
    //        [mDict setObject:@"" forKey:@"access_token"];
    //    }
    //
    //    [mDict setObject:@"app" forKey:@"type"];
    return mDict;
}
//获取get参数
- (NSDictionary*)fullParamFromDictionary:(NSDictionary*)dict
{
    if (!dict) {
        return nil;
    }
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSDictionary *comMDict = [self getCommonParameter];
    [paramDict setValuesForKeysWithDictionary:comMDict];
    
    return paramDict;
}

#pragma mark-- 外部API
/**
 *	@brief	get请求
 *
 *	@param 	url 	    请求地址
 *	@param 	parameters 	请求参数
 *	@param
 *
 */
- (void)getRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameters
                   object:(id)object
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *error))failure
{
    [self getRequestWithUrl:url parameters:parameters headerFields:nil object:object style:0 success:success failure:failure];
}

/**
 *	@brief	get请求
 *
 *	@param 	url 	    请求地址
 *	@param 	parameters 	请求参数
 *	@param  object      回调对象
 *	@param  style       接口类型
 *
 */
- (void)getRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameters
                   object:(id)object
                    style:(NSInteger)style
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *error))failure
{
    [self getRequestWithUrl:url parameters:parameters headerFields:nil object:object style:style success:success failure:failure];
    
}

/**
 *	@brief	get请求
 *
 *	@param 	url 	     请求地址
 *	@param 	parameters 	 请求参数
 *  @param  headerFields 请求消息头
 *	@param  object       回调对象
 *	@param  style        接口类型
 *
 */
- (void)getRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameters
             headerFields:(NSDictionary*)headerFields
                   object:(id)object
                    style:(NSInteger)style
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *error))failure
{
    NSDictionary *paramDict = [self fullParamFromDictionary:parameters];
    
    //add cookie
//    NSDictionary *headDict = [BAFGlobalMananger setHTTPCookieForKey:kUserDefaultsCookie withUrl:kLoginUrl];
//    if (headDict) {
//        if (!headerFields) {
//            headerFields = headDict;
//        }
//        else
//        {
//            [headerFields setValuesForKeysWithDictionary:headDict];
//        }
//    }
    
    //end
    NLReqestMessage *msg = [NLReqestMessage createReqMsg:url parameters:paramDict headerFields:headerFields object:object style:style];
    [msg displayRequestUrl];
    //网络请求
    [[NLHttpClientModel sharedInstance] getReqMsg:msg success:^(id operation, id responseObject) {
        //过滤部分code，处理 errorCode，如果1000、2000、3000、则重新获取Token
        [self errorCodeDealWithDictionary:responseObject];

        success(operation, responseObject);
    } failure:^(id operation, NSError *error) {
        //
        failure(operation, error);
    }];
    
}

#pragma mark-- POST请求
#pragma mark ------请求消息体内容DICT,需要拼接KEY=VALUE键值对，字符流
/**
 *	@brief	post请求
 *
 *	@param 	params 	请求参数
 *	@param 	body 	请求内容DICT,需要拼接KEY=VALUE键值对
 *	@param  object       回调对象
 *
 */
- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
                paramsBody:(NSDictionary*)body
                    object:(id)object
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    [self postRequestWithUrl:url parameters:params headerFields:nil paramsBody:body object:object style:0 success:success failure:failure];
}

/**
 *	@brief	post请求
 *
 *	@param 	params 	请求参数
 *	@param 	headerFields 	消息头信息
 *	@param 	body 	请求内容DICT,需要拼接KEY=VALUE键值对
 *	@param  object       回调对象
 *	@param  style        接口类型
 *
 */
- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
              headerFields:(NSDictionary*)headerFields
                paramsBody:(NSDictionary*)body
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    
    NSDictionary *paramDict = [self fullParamFromDictionary:params];
    NLReqestMessage *msg = [NLReqestMessage createReqMsg:url parameters:paramDict headerFields:headerFields body:body object:object style:style];
    [msg displayRequestUrl];
    
    //网络请求
    [[NLHttpClientModel sharedInstance] postReqMsg:msg bodyBlock:^NSString *(id parameters) {
        
        if (!parameters) {
            return nil;
        }
        
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSString *dataString = [NSString mm_URLParamStringFromDictionary:parameters];
            return dataString;
        }
        
        return nil;
        
    } success:^(id operation, id responseObject) {
        //过滤部分code，处理 errorCode，如果1000、2000、3000、则重新获取Token
        [self errorCodeDealWithDictionary:responseObject];
        success(operation, responseObject);
        
    } failure:^(id operation, NSError *error) {
        //
        failure(operation, error);
    }];
    
}

#pragma mark ------请求消息体内容,内部拼装data=json串，字符流
/**
 *	@brief	post请求
 *
 *	@param 	params 	请求参数
 *	@param 	body 	请求内容,内部拼装data=json串
 *	@param  object       回调对象
 *	@param  style        接口类型
 *
 */
- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
                paramsBody:(id)body
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    
    NSDictionary *paramDict = [self fullParamFromDictionary:params];
    NLReqestMessage *msg = [NLReqestMessage createReqMsg:url parameters:paramDict headerFields:nil body:body object:object style:style];
    [msg displayRequestUrl];
    
    //网络请求
    [[NLHttpClientModel sharedInstance] postReqMsg:msg bodyBlock:^NSString *(id parameters) {
        
        if (!parameters) {
            return nil;
        }
        
        NSError *err;
        NSData  *strdata = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&err];
        NSString *reqString = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
        NSLog(@"reqString = %@", reqString);
        NSString *dataString = [NSString stringWithFormat:@"%@=%@",@"data",reqString];
        
        return dataString;
        
    } success:^(id operation, id responseObject) {
        [self errorCodeDealWithDictionary:responseObject];
        success(operation, responseObject);
        
    } failure:^(id operation, NSError *error) {
        //
        failure(operation, error);
    }];
    
}


/**
 *	@brief	post请求
 *
 *	@param 	params 	请求参数
 *	@param 	body 	body消息体为原始数据，不需要组装格式
 *	@param  object       回调对象
 *	@param  style        接口类型
 *
 */
- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
                      body:(id)body
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    
    [self postRequestWithUrl:url parameters:params headerFields:nil body:body object:object style:style success:success failure:failure];
    
}

- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
              headerFields:(NSDictionary*)headerFields
                      body:(id)body
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    NSDictionary *paramDict = [self fullParamFromDictionary:params];
    NLReqestMessage *msg = [NLReqestMessage createReqMsg:url parameters:paramDict headerFields:headerFields body:body object:object style:style];
    [msg displayRequestUrl];
    
    //网络请求
    [[NLHttpClientModel sharedInstance] postReqMsg:msg success:^(id operation, id responseObject) {
        
        [self errorCodeDealWithDictionary:responseObject];
        
        success(operation, responseObject);
    } failure:^(id operation, NSError *error) {
        failure(operation, error);
    }];
    
}

#pragma mark-- 表单提交
- (void)postFormDataWithUrl:(NSString*)url
                   fileData:(NSData*)fileData
                 parameters:(NSDictionary*)params
                     object:(id)object
                    success:(void (^)(id operation, id responseObject))success
                    failure:(void (^)(id operation, NSError *error))failure
{
    [self postFormDataWithUrl:url formData:fileData parameters:params object:object style:0 success:success failure:failure];
}

- (void)postFormDataWithUrl:(NSString*)url
                   formData:(id)formData
                 parameters:(NSDictionary*)params
                     object:(id)object
                      style:(NSInteger)style
                    success:(void (^)(id operation, id responseObject))success
                    failure:(void (^)(id operation, NSError *error))failure
{
    [self postFormDataWithUrl:url formData:formData parameters:params headerFields:nil object:object style:style success:success failure:failure];
}

- (void)postFormDataWithUrl:(NSString*)url
                   formData:(id)formData
                 parameters:(NSDictionary*)params
               headerFields:(NSDictionary*)headerFields
                     object:(id)object
                      style:(NSInteger)style
                    success:(void (^)(id operation, id responseObject))success
                    failure:(void (^)(id operation, NSError *error))failure
{
    
    NSDictionary *parameters = nil;
    if (params) {
        parameters = [self fullParamFromDictionary:params];
    }
    
    NLReqestMessage *msg = [NLReqestMessage createReqMsg:url parameters:parameters headerFields:headerFields body:formData object:object style:style];
    msg.timeOut = 60.0;
    [msg displayRequestUrl];
    
    [[NLHttpClientModel sharedInstance] postFormDataReqMsg:msg success:^(id operation, id responseObject) {
        [self errorCodeDealWithDictionary:responseObject];
        
        success(operation, responseObject);
    } failure:^(id operation, NSError *error) {
        //
        failure(operation, error);
    }];
    
}

#pragma mark-- 上传图片接口
- (void)uploadImageWithUrl:(NSString*)url
                  fileData:(NSData*)fileData
                parameters:(NSDictionary*)params
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    
    NSDictionary *parameters = [self fullParamFromDictionary:params];
    NLReqestMessage *msg = [NLReqestMessage createReqMsg:url parameters:parameters headerFields:nil body:fileData object:object style:style];
    [msg displayRequestUrl];
    
    [[NLHttpClientModel sharedInstance] uploadImageReqMsg:msg success:^(id operation, id responseObject) {
        //过滤部分code，处理 errorCode重新获取Token
        [self errorCodeDealWithDictionary:responseObject];
        
        success(operation, responseObject);
    } failure:^(id operation, NSError *error) {
        failure(operation, error);
    }];
    
}

#pragma mark -- 错误处理（需要重新登录的情况）
- (void)errorCodeDealWithDictionary:(NSDictionary*)JSON
{
    //过滤部分code，处理 errorCode，如果101、102 则重新获取Token(100是否为未登陆？)
    //100:没有访问权限;101:token 无效(token 过期后,再次请求); 102:token 过期
    //注意这里没有处理404:未定义的接口这种请求出错的情况
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        [LLErrorOfRequest errorCodeDealWith:[JSON[@"code"] intValue]];
    }
    
}

#pragma mark - 处理 errorCode，如果100、101、102、则重新获取Token
-(void)errorCodeDealWith:(int)errorCode
{
    [LLErrorOfRequest errorCodeDealWith:errorCode];
}
@end
