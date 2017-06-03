//
//  NLHttpeClientModel.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NLHttpClientModel.h"
#import "AFNetworking.h"
#import "NLRequestMessageManager.h"

#pragma mark - SSL验证
/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL isOpenHttpsSSL()
/**
 *  SSL 证书名称，仅支持cer格式。“app.bishe.com.cer”,则填“app.bishe.com”
 */
#ifdef PUBLISHCONFIG
#define certName @"https"//需要更改服务器给的证书名称（公钥）
#else
#define certName @"https"//正式环境下的
#endif

BOOL isOpenHttpsSSL()
{
#ifdef kOpenHttpsSSL
    return YES;
#else
    return NO;
#endif
}


#pragma mark - 请求封装类实现
@implementation NLHttpClientModel

+ (NLHttpClientModel*)sharedInstance
{
    static NLHttpClientModel *sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NLHttpClientModel alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark -- 外部接口API
//get消息请求  API
- (void)getReqMsg:(NLReqestMessage*)msg
          success:(void (^)(id operation, id responseObject))success
          failure:(void (^)(id operation, NSError *error))failure
{
    //步骤：1获取AFHTTPSessionManager对象，2根据manager的requestSerializer设置超时时间以及请求头，3ssl验证，4根据manager得到NSURLSeesionDataTask（已经resume），5调用invalidate
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:msg.timeOut];
    
    if (msg.headerFields) {
        for (NSString *key in msg.headerFields.allKeys) {
            [manager.requestSerializer setValue:msg.headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    // 加上这行代码，https ssl 验证。
//    if(openHttpsSSL)
//    {
//        [manager setSecurityPolicy:[self customSecurityPolicy]];
//    }
    
    NSURLSessionDataTask *task = [manager GET:msg.url parameters:msg.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        REMOVEREQMSG(msg);//将msg从请求消息管理类中消息列表移除
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        REMOVEREQMSG(msg);
        
        if ((error.code == NSURLErrorCancelled)) {
            NSLog(@"error.code = %ld", NSURLErrorCancelled);
            return ;
        }
        
        failure(task, error);
    }];
    
    //    NSLog(@"url = %@", task.currentRequest.URL);
    //对task进行管理，用来处理请求取消队列
    ADDREQMSG(msg, task);
    
    //完成后关闭会话
    [manager invalidateSessionCancelingTasks:NO];
    
}

//post消息请求 body消息体为原始数据，不需要组装格式
- (void)postReqMsg:(NLReqestMessage*)msg
           success:(void (^)(id operation, id responseObject))success
           failure:(void (^)(id operation, NSError *error))failure
{
    //步骤：1获取AFHTTPSessionManager对象，2根据manager的requestSerializer设置超时时间以及请求头，2-1requestSerializer设置content-type，2-2requestSerializer设置setQueryStringSerializationWithBlock，3ssl验证，4根据manager得到NSURLSeesionDataTask（已经resume），5调用invalidate
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:msg.timeOut];
    
    if (msg.headerFields) {
        for (NSString *key in msg.headerFields.allKeys) {
            [manager.requestSerializer setValue:msg.headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    //content-type: text/html,AFNetWork对类型支持不够
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    //设置消息体
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        //POST消息体 json格式
        if (!parameters) {
            return nil;
        }
        
        NSError *err;
        NSData  *strdata = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&err];
        NSString *bodyString = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
        
        return bodyString;
        
    }];
    
    NSString *reqUrl = [msg getRequestUrl];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    
    NSURLSessionDataTask *task = [manager POST:reqUrl parameters:msg.body progress:^(NSProgress * _Nonnull uploadProgress) {
        //
        NSLog(@"uploadProgress = %@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        REMOVEREQMSG(msg);
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        REMOVEREQMSG(msg);
        failure(task, error);
    }];
    
    //    NSLog(@"url = %@", task.currentRequest.URL);
    //对task进行管理，用来处理请求取消队列
    ADDREQMSG(msg, task);
    
    //完成后关闭会话
    [manager invalidateSessionCancelingTasks:NO];
}

//body消息体，需要将《body消息参数》按《格式》组装成body消息体
- (void)postReqMsg:(NLReqestMessage*)msg
         bodyBlock:(NLRequestMessageBodyBlock)bodyBlock
           success:(void (^)(id operation, id responseObject))success
           failure:(void (^)(id operation, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:msg.timeOut];
    if (msg.headerFields) {
        for (NSString *key in msg.headerFields.allKeys) {
            [manager.requestSerializer setValue:msg.headerFields[key] forHTTPHeaderField:key];
        }
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    //设置消息体
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        //POST消息体 json格式
        if (!parameters) {
            return nil;
        }
        
        NSString *dataString = bodyBlock(parameters);
        
        return (dataString != nil)?dataString:nil;
        
    }];
    
    NSString *reqUrl = [msg getRequestUrl];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionDataTask *task = [manager POST:reqUrl parameters:msg.body progress:^(NSProgress * _Nonnull uploadProgress) {
        //
        NSLog(@"uploadProgress = %@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        REMOVEREQMSG(msg);
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        REMOVEREQMSG(msg);
        failure(task, error);
    }];
    
    //    NSLog(@"url = %@", task.currentRequest.URL);
    //对task进行管理，用来处理请求取消队列
    ADDREQMSG(msg, task);
    
    //完成后关闭会话
    [manager invalidateSessionCancelingTasks:NO];
}

//上传图片
- (void)uploadImageReqMsg:(NLReqestMessage*)msg
                  success:(void (^)(id operation, id responseObject))success
                  failure:(void (^)(id operation, NSError *error))failure
{
    //步骤：1获取AFHTTPSessionManager对象，2根据manager的requestSerializer设置超时时间以及请求头，2-1requestSerializer设置content-type，2-2根据1requestSerializer生成请求request，且该请求//将parameters和formData内容组合到一起。，3ssl验证，4根据manager得到NSURLSessionUploadTask（未resume），5调用invalidate
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:msg.timeOut];
    if (msg.headerFields) {
        for (NSString *key in msg.headerFields.allKeys) {
            [manager.requestSerializer setValue:msg.headerFields[key] forHTTPHeaderField:key];
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString *fileName = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]];
    NSString *reqUrl = [msg getRequestUrl];
    
    NSMutableURLRequest *mRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:reqUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:msg.body name:@"img" fileName:fileName mimeType:@"image/png"];
        
    } error:nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:mRequest fromData:nil progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //
        REMOVEREQMSG(msg);
        //响应数据
        if (error) {
            failure(response, error);
        } else {
            success(response, responseObject);
        }
        
    }];
    
    ADDREQMSG(msg, uploadTask);
    
    [uploadTask resume];//没有resume?
    
    //完成后关闭会话
    [manager invalidateSessionCancelingTasks:NO];
}

//表单上传 MultipartFormData
- (void)postFormDataReqMsg:(NLReqestMessage*)msg
                   success:(void (^)(id operation, id responseObject))success
                   failure:(void (^)(id operation, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置超时时间30S
    [manager.requestSerializer setTimeoutInterval:msg.timeOut];
    if (msg.headerFields) {
        for (NSString *key in msg.headerFields.allKeys) {
            [manager.requestSerializer setValue:msg.headerFields[key] forHTTPHeaderField:key];
        }
        
    }
    [manager.requestSerializer setValue:@"multipart/form-data"forHTTPHeaderField:@"Contsetent-Type"];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    NSString *fileName = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]*1000];
    NSString *reqUrl = [msg getRequestUrl];
    
    NSMutableURLRequest *mRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:reqUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([msg.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *parameters = (NSDictionary*)msg.body;
            for (NSString *key in parameters.allKeys) {
                
                if ([parameters[key] isKindOfClass:[NSString class]]) {
                    [formData appendPartWithFormData:[parameters[key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
                }
                else if([parameters[key] isKindOfClass:[NSNumber class]])
                {
                    NSString *value = [NSString stringWithFormat:@"%@", parameters[key]];
                    [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
                }
                else if([parameters[key] isKindOfClass:[UIImage class]])
                {
                    UIImage *image = parameters[key];
                    NSData* data = UIImagePNGRepresentation(image);
                    [formData appendPartWithFileData:data name:key fileName:fileName mimeType:@"image/png"];
                }
                else if([parameters[key] isKindOfClass:[NSArray class]])
                {
                    //处理图片数组
                    for (id element in parameters[key]) {
                        if([element isKindOfClass:[UIImage class]])
                        {
                            NSString *imageName = [NSString stringWithFormat:@"%lld", (long long)[[NSDate date] timeIntervalSince1970]*1000];
                            NSData* data = UIImagePNGRepresentation(element);
                            [formData appendPartWithFileData:data name:key fileName:imageName mimeType:@"image/png"];
                        }
                    }
                }
            }
        }
        else if([msg.body isKindOfClass:[NSData class]])
        {
            [formData appendPartWithFileData:msg.body name:@"image" fileName:fileName mimeType:@"image/png"];
        }
        
        
    } error:nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL)
    {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    
    //    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:mRequest fromData:nil progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    //        //
    //        REMOVEREQMSG(msg);
    //        //响应数据
    //        if (error) {
    //            failure(response, error);
    //        } else {
    //            success(response, responseObject);
    //        }
    //
    //    }];
    
    //add
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:mRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        //
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            //Update the progress view
        //        });
        NSLog(@"uploadProgress = %f", uploadProgress.fractionCompleted);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //
        NSLog(@"responseObject = %@", responseObject);
        REMOVEREQMSG(msg);
        //响应数据
        if (error) {
            failure(response, error);
        } else {
            success(response, responseObject);
        }
    }];
    //end
    
    ADDREQMSG(msg, uploadTask);
    
    [uploadTask resume];
    
    //完成后关闭会话
    [manager invalidateSessionCancelingTasks:NO];
}

////表单
//- (void)test
//{
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
//
//    } error:nil];
//
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [manager
//                  uploadTaskWithStreamedRequest:request
//                  progress:^(NSProgress * _Nonnull uploadProgress) {
//                      // This is not called back on the main queue.
//                      // You are responsible for dispatching to the main queue for UI updates
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                          //Update the progress view
//                          [progressView setProgress:uploadProgress.fractionCompleted];
//                      });
//                  }
//                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                      if (error) {
//                          NSLog(@"Error: %@", error);
//                      } else {
//                          NSLog(@"%@ %@", response, responseObject);
//                      }
//                  }];
//
//    [uploadTask resume];
//}


#pragma mark -- SSL证书验证
- (AFSecurityPolicy*)customSecurityPolicy
{
#ifndef kCancelHttpsValidation
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certName ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
#endif
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
#ifndef kCancelHttpsValidation
    securityPolicy.pinnedCertificates = @[certData];
#endif
    return securityPolicy;
}

@end
