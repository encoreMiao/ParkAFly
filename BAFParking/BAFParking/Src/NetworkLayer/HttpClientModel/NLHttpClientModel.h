//
//  NLHttpeClientModel.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NLReqestMessage;

typedef NSString* (^NLRequestMessageBodyBlock) (id parameters);


@interface NLHttpClientModel : NSObject
/**
 *	@brief	获取逻辑管理对象单例
 *
 *	@return	网络管理对象单例
 */
+ (NLHttpClientModel*)sharedInstance;

#pragma mark -- 新引入消息管理系统接口API
/**
 *	@brief	    get请求
 *
 *
 */
- (void)getReqMsg:(NLReqestMessage*)msg
          success:(void (^)(id operation, id responseObject))success
          failure:(void (^)(id operation, NSError *error))failure;

/**
 *	@brief	    post请求，body消息参数不需处理，直接作为body消息体
 *
 *
 */
- (void)postReqMsg:(NLReqestMessage*)msg
           success:(void (^)(id operation, id responseObject))success
           failure:(void (^)(id operation, NSError *error))failure;

/**
 *	@brief	    post请求，需要将《body消息参数》按《格式》组装成body消息体
 *  @bodyBlock  消息体格式，返回NSString类型
 *
 */
- (void)postReqMsg:(NLReqestMessage*)msg
         bodyBlock:(NLRequestMessageBodyBlock)bodyBlock
           success:(void (^)(id operation, id responseObject))success
           failure:(void (^)(id operation, NSError *error))failure;

/**
 *	@brief	   上传图片
 *  @msg       msg.body为fileData(文件或图片数据)
 *
 */
- (void)uploadImageReqMsg:(NLReqestMessage*)msg
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *error))failure;

//表单上传 MultipartFormData
- (void)postFormDataReqMsg:(NLReqestMessage*)msg
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure;
@end
