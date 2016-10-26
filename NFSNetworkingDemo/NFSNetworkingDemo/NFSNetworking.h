//
//  NFSNetworking.h
//  AFNetworking33333.0Include
//
//  Created by Persagy研发 on 2016/10/18.
//  Copyright © 2016年 sqdxxx. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString * _Nonnull const NFSNetworkingTypeDefault;

#define kNFSNetworking [[NFSNetworking alloc] initWithType:NFSNetworkingTypeDefault]

#if DEBUG
#define NFSJSONLog(idObject) do{\
NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:idObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];\
NSLog(@"🔴\n%@",jsonString);\
}while(0)
#else
#define NFSJSONLog(idObject)
#endif

#define send_data autoreleasepool{};\
_send_data

#define cancel autoreleasepool{};\
_cancel

#define serial autoreleasepool{};\
_serialApi

#define concurrency autoreleasepool{};\
_concurrencyApi


#define finish autoreleasepool{};\
dispatch_group_leave(group);

extern void _serialApi( NSString *name,void (^block)() );
extern void _concurrencyApi(void(^block)(dispatch_group_t group));
extern void _send_data(id data);
extern void _cancel();

@protocol NFSNetworkingDelegate <NSObject>
- (void)apiFinish:(NSURLSessionDataTask * _Nonnull)task data:(id _Nullable)data error:(NSError * _Nullable)error;
@end

@interface NFSNetworking : NSObject

//- (void)sendData:(id)data branch:(NSString*)branch; // 用于分支

- (instancetype _Nullable)initWithType:(NSString* _Nonnull)typeString;

// POST
- (NSURLSessionDataTask* _Nullable)apiPOST:(NSString * _Nullable)URLString
                      parameters:(id _Nullable)parameters
                        progress:(void (^ _Nullable)(NSProgress * _Nonnull))uploadProgress
                         success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                         failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;


- (NSURLSessionDataTask* _Nullable)apiPOST:(NSString * _Nullable)URLString
                                parameters:(id _Nullable)parameters
                                  progress:(void (^ _Nullable)(NSProgress * _Nonnull))uploadProgress
                                  delegate:(id <NFSNetworkingDelegate> _Nullable)delegate;
@end
