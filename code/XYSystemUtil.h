//
//  XYSystemUtil.h
//  XYDeviceInfo
//
//  Created by steve on 2020/7/23.
//

#import <Foundation/Foundation.h>

@interface XYSystemUtil : NSObject

// 设备名称，例如 My iPhone
+ (NSString *)getDeviceUserName;

// 系统版本
+ (NSString *)getSystemVersion;

// 产品型号
+ (NSString *)getIphoenModel;

// 系统语言
+ (NSString *)getSystemLanguage;

// 运营商
+ (NSString *)getOperator;

// 逻辑分辨率
+ (NSString *)getLogicalResolution;

// 缩放因子
+ (NSString *)getScalingFactor;

// 屏幕分辨率
+ (NSString *)getResolution;

// CPU架构
+ (NSString *)getCPUArchitecture;

// CPU数目
+ (NSString *)getCPUNumber;

// CPU使用总比例
+ (NSString *)getCPUUsed;

// 内存总容量
+ (NSString *)getMemoryWithTotal;

// 内存已使用
+ (NSString *)getMemoryWithUsed;

// 内存剩余容量
+ (NSString *)getMemoryWithFree;

// 磁盘总容量
+ (NSString *)getDickWithTotal;

// 磁盘已使用
+ (NSString *)getDickWithUsed;

// 磁盘剩余容量
+ (NSString *)getDickWithFree;

// 剩余电量
+ (NSString *)getBatteryWithFree;

// 电池状态
+ (NSString *)getBatteryWithState;

// 网络状态
+ (NSString *)getNetworkStatus;

// IPV4地址
+ (NSString *)getIPAddressWithIPV4;

// IPV6地址
+ (NSString *)getIPAddressWithIPV6;

// 是否开启IDFA
+ (BOOL)canUseIDFA;

// IDFA
+ (NSString *)idfa;

// IDFA
+ (NSString *)idfv;

@end
