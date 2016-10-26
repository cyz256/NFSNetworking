//
//  NFSNetworking.m
//  AFNetworking33333.0Include
//
//  Created by Persagy研发 on 2016/10/18.
//  Copyright © 2016年 sqdxxx. All rights reserved.
//

#import "NFSNetworking.h"
#import <AFNetworking.h>


#define kBaseApi @"http://139.129.212.51:7777/EMS_Service_V/rest/ServiceView/qureyArrayStr/"
#define kImageUploadApi @"http://139.129.212.51:7777/EMS_File/Spring/MVC/upload/multi"
#define kImageDownloadApi @"http://139.129.212.51:7777"


NSString *const NFSNetworkingTypeDefault = @"_defaultCustom";


static NSMutableArray *serialArray;
static dispatch_group_t group;


@interface NFSNetworking ()

@property (nonatomic, readwrite, strong) AFHTTPSessionManager *manager;
@property (nonatomic, readwrite, strong) NSMutableArray *serialArray;

@end

@implementation NFSNetworking


- (instancetype)initWithType:(NSString*)typeString
{
    self = [super init];
    if (self) {
        _manager = [self _createManagerWithType:typeString];
    }
    return self;
}

#pragma mark - GET

//- (nullable NSURLSessionDataTask *)apiGET:(NSString *)URLString
//                            parameters:(nullable id)parameters
//                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
//                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
//                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
//    
//    
//    return [_manager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
//    
//}

#pragma mark - POST

- (NSURLSessionDataTask* _Nullable)apiPOST:(NSString * _Nullable)URLString
                                parameters:(id _Nullable)parameters
                                  progress:(void (^ _Nullable)(NSProgress * _Nonnull))uploadProgress
                                  delegate:(id <NFSNetworkingDelegate> _Nullable)delegate{
    
   return [self apiPOST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask * task, id data) {
       if ([delegate respondsToSelector:NSSelectorFromString(@"apiFinish:data:error:")]) {
           [delegate apiFinish:task data:data error:nil];
       }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        if ([delegate respondsToSelector:NSSelectorFromString(@"apiFinish:data:error:")]) {
            [delegate apiFinish:task data:nil error:error];
        }
    }];
}

- (NSURLSessionDataTask*)apiPOST:(NSString *)URLString
                      parameters:(id)parameters
                        progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                         failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    
    if (!URLString) {
        URLString = @"";
    }
    
    NSCParameterAssert(parameters);
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[parameters] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"params": string};
    
    
    void (^tempSuccess)(NSURLSessionDataTask * _Nonnull, id _Nullable) = ^(NSURLSessionDataTask * task, id data){
        
        // code for responsed
        
        // token 更新操作
        
        
        
        NFSJSONLog(data);
        if (success) { success(task, data);}
    };
    
    return [_manager POST:URLString parameters:dic progress:uploadProgress success:tempSuccess failure:failure];
}


#pragma mark - 串行 SERIAL


void _send_data(id data){
    
    if (serialArray.count < 2) {
        return;
    }
    void (^block)() = serialArray[1];
    block(data);
    [serialArray removeObjectAtIndex:0];
}


void _cancel(){
    [serialArray removeAllObjects];
    group = nil;
}

void _serialApi(NSString *name,void (^block)(id))// 并串时，参数可能需要前面全部获得的数据。
{
    if (!serialArray) {serialArray = [[NSMutableArray alloc] initWithCapacity:3];}
    
    if (block) {
        [serialArray addObject:block];
    }
    if (serialArray.count == 1) {
        block(nil);
    }
    
    if (group) {
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            block(nil);
        });
    }
}


#pragma mark - 并行

void _concurrencyApi(void(^block)(dispatch_group_t group)){
    
    if (!group) {group = dispatch_group_create();}
    dispatch_group_enter(group);
    
    block(group);
}

- (AFHTTPSessionManager*)_createManagerWithType:(NSString*)typeString{
    
    NSCParameterAssert(typeString);
    SEL select = NSSelectorFromString(typeString);
    if ([self respondsToSelector:select]) {
        IMP imp = [self methodForSelector:select];
        id (*func)(id, SEL) = (void *)imp;
        return func(self, select);
    }
    return nil;
}


#pragma mark - 私有函数

- (void)_prefixOfApi{
    
    // do something for request common
    
}

#pragma mark - 默认

- (AFHTTPSessionManager*)_defaultCustom{
    NSURL *URL = [NSURL URLWithString:kBaseApi];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    return manager;
}

#pragma mark 下载

@end
