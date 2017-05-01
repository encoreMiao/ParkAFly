//
//  LLBaseRequest.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCallBackInterface.h"

@interface LLBaseRequest : NSObject
/**
 *	@brief	get请求
 *
 *	@param 	url 	    请求地址
 *	@param 	parameters 	请求参数
 *	@param  object      回调对象
 *
 */
- (void)getRequestWithUrl:(NSString*)url
               parameters:(NSDictionary*)parameters
                   object:(id)object
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *error))failure;

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
                  failure:(void (^)(id operation, NSError *error))failure;

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
                  failure:(void (^)(id operation, NSError *error))failure;

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
                   failure:(void (^)(id operation, NSError *error))failure;

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
                   failure:(void (^)(id operation, NSError *error))failure;

#pragma mark ------请求消息体内容,内部拼装data=json串，字符流
/**
 *	@brief	post请求 需要将《body消息参数》按《格式》组装成body消息体
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
                   failure:(void (^)(id operation, NSError *error))failure;

/**
 *	@brief	post请求 body消息体为原始数据，不需要组装格式
 *
 *	@param 	params 	请求参数
 *	@param 	body 	消息体
 *
 */
#pragma mark ------请求消息体内容,内部拼装json串，字符流
- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
                      body:(id)body
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure;

- (void)postRequestWithUrl:(NSString*)url
                parameters:(NSDictionary*)params
              headerFields:(NSDictionary*)headerFields
                      body:(id)body
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure;

#pragma mark-- 表单提交
- (void)postFormDataWithUrl:(NSString*)url
                   fileData:(NSData*)fileData
                 parameters:(NSDictionary*)params
                     object:(id)object
                    success:(void (^)(id operation, id responseObject))success
                    failure:(void (^)(id operation, NSError *error))failure;

- (void)postFormDataWithUrl:(NSString*)url
                   formData:(id)formData
                 parameters:(NSDictionary*)params
                     object:(id)object
                      style:(NSInteger)style
                    success:(void (^)(id operation, id responseObject))success
                    failure:(void (^)(id operation, NSError *error))failure;

- (void)postFormDataWithUrl:(NSString*)url
                   formData:(id)formData
                 parameters:(NSDictionary*)params
               headerFields:(NSDictionary*)headerFields
                     object:(id)object
                      style:(NSInteger)style
                    success:(void (^)(id operation, id responseObject))success
                    failure:(void (^)(id operation, NSError *error))failure;

#pragma mark-- 上传图片接口
- (void)uploadImageWithUrl:(NSString*)url
                  fileData:(NSData*)fileData
                parameters:(NSDictionary*)params
                    object:(id)object
                     style:(NSInteger)style
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure;
@end
