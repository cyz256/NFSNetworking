//
//  ViewController.m
//  AFNetworking33333.0Include
//
//  Created by Persagy研发 on 2016/10/18.
//  Copyright © 2016年 sqdxxx. All rights reserved.
//

#import "ViewController.h"
#import "NFSNetworking.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dic = @{
                          @"version" : @"0.2",
                          @"type" : @"ledgerView",
                          @"ledgerView" : @{
                                  @"collection" : @"SoHoUserLogin"
                                  },
                          @"criteria" : @{
                                  @"id" : @"aaaaa",
                                  @"password": @"bbbbb"
                                  }
                          };
    
    // 串行请求
    
    @serial(@"部门", ^(NSArray *data){
        
        [kNFSNetworking apiPOST:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * task , id data) {
            NSLog(@"部门数据 = %@", data);
            @send_data(data);
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            
        }];
    });
    
    @serial(@"办公室", ^(NSArray *data){
        
        [kNFSNetworking apiPOST:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * task , id data) {
            
            NSLog(@"办公室数据 = %@", data);
            @cancel();
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            
        }];
    });
    
    
    
    
    // 并行请求
    
    @concurrency(^(dispatch_group_t group) {
        
        [kNFSNetworking apiPOST:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * task , id data) {
            NSLog(@"部门打印 = %@", data);
            
            @finish;
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            
        }];
    });
    
    @concurrency(^(dispatch_group_t group) {
        
        [kNFSNetworking apiPOST:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * task , id data) {
            NSLog(@"部门打印 = %@", data);
            
            @finish;
            
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            @cancel;
        }];
    });
    
    @serial(nil, ^{
        
        [kNFSNetworking apiPOST:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * task , id data) {
            NSLog(@"每个部门全部人员 = %@", data);
            
            @cancel;
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            
        }];
    });
    
}

@end
