//
//  XYSystemUtil.m
//  XYDeviceInfo
//
//  Created by steve on 2020/7/23.
//

#import "XYSystemUtil.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
#import <ifaddrs.h> // 获取ip
#import <arpa/inet.h> // 获取ip
#import <net/if.h> // 获取ip
#include <mach/mach.h> // 获取内存
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#import <AdSupport/AdSupport.h>
#import "XYManager.h"

static NSString *XY_ZeroIdfa = @"00000000-0000-0000-0000-000000000000";

@implementation XYSystemUtil

// 设备名称，例如 My iPhone
+ (NSString *)getDeviceUserName {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *name = device.name;
    return name;
}

// 获取系统版本号
+ (NSString *)getSystemVersion {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *str = device.systemVersion;
    return str;
}

// 产品型号
+ (NSString *)getIphoenModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

// 系统语言
+ (NSString *)getSystemLanguage {
    NSString *str = [[NSLocale preferredLanguages] objectAtIndex:0];
    return str;
}

// 运营商
+ (NSString *)getOperator {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        mobile = @"未知";
    }
    else{
        mobile = [carrier carrierName];
    }
    return mobile;
}

// 逻辑分辨率
+ (NSString *)getLogicalResolution {
    NSString *w = [NSString stringWithFormat:@"%.0f",[[UIScreen mainScreen] bounds].size.width];
    NSString *h = [NSString stringWithFormat:@"%.0f",[[UIScreen mainScreen] bounds].size.height];
    NSString *str = [NSString stringWithFormat:@"%@*%@",w,h];
    return str;
}

// 缩放因子
+ (NSString *)getScalingFactor {
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *str = [NSString stringWithFormat:@"%.0f",scale];
    return str;
}

// 屏幕分辨率
+ (NSString *)getResolution {
    NSString *w = [NSString stringWithFormat:@"%.0f",[[UIScreen mainScreen] bounds].size.width * [[UIScreen mainScreen] scale]];
    NSString *h = [NSString stringWithFormat:@"%.0f",[[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] scale]];
    NSString *str = [NSString stringWithFormat:@"%@*%@",w,h];
    return str;
}

// CPU架构
+ (NSString *)getCPUArchitecture {
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            return @"ARM 32";
            break;
            
        case CPU_TYPE_ARM64:
            return @"ARM 64";
            break;
            
        case CPU_TYPE_X86:
            return @"x86";
            break;
            
        case CPU_TYPE_X86_64:
            return @"x86 64";
            break;
            
        default:
            return @"未知";
            break;
    }
}

// CPU数目
+ (NSString *)getCPUNumber {
    unsigned int ncpu;
    size_t len = sizeof(ncpu);
    sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
    NSString *str = [NSString stringWithFormat:@"%i",ncpu];
    return str;
}

// CPU使用总比例
+ (NSString *)getCPUUsed {
    
    NSString *str;
    
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return @"Unknown";
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads

    basic_info = (task_basic_info_t)tinfo;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        str = @"Unknown";
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            str = @"Unknown";
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    str = [NSString stringWithFormat:@"%.2f%%",tot_cpu];
    
    return str;
}

// 内存总容量
+ (NSString *)getMemoryWithTotal {
//    vm_statistics_data_t vmStats;
//    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
//    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
//
//    if (kernReturn != KERN_SUCCESS) {
//        return @"Unknown";
//    }
//    double total = ((vm_page_size * vmStats.free_count) / 1024.0)/1024.0;
//    NSString *str = [NSString stringWithFormat:@"%0.fMB",total];
//    return str;
    long long total = [NSProcessInfo processInfo].physicalMemory;
    NSString *str = [NSString stringWithFormat:@"%.0fGB",total/1024.0/1024.0/1024.0];
    return str;
}

// 内存已使用
+ (NSString *)getMemoryWithUsed {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return @"Unknown";
    }
    
    long long used = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
    NSString *str = [NSString stringWithFormat:@"%.0fGB",used/1024.0/1024.0/1024.0];
    return str;
}

// 内存剩余容量
+ (NSString *)getMemoryWithFree {
    long long total = [NSProcessInfo processInfo].physicalMemory;
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return @"Unknown";
    }
    
    long long used = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
    
    NSString *str = [NSString stringWithFormat:@"%.0fGB",(total-used)/1024.0/1024.0/1024.0];
    return str;
}

// 磁盘总容量
static const u_int Adsforce_GIGABYTE = 1024 * 1024 * 1024;  // bytes
+ (NSString *)getDickWithTotal {
    NSDictionary *attrs = [[[NSFileManager alloc] init] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float totalDiskSpace = [[attrs objectForKey:NSFileSystemSize] floatValue];
    unsigned long long totalDiskSpaceGB = (unsigned long long)round(totalDiskSpace / Adsforce_GIGABYTE);
    NSString *str = [NSString stringWithFormat:@"%lldGB",totalDiskSpaceGB];
    return str;
}

// 磁盘剩余容量
+ (NSString *)getDickWithFree {
    NSDictionary *attrs = [[[NSFileManager alloc] init] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float remainingDiskSpace = [[attrs objectForKey:NSFileSystemFreeSize] floatValue];
    unsigned long long remainingDiskSpaceGB = (unsigned long long)round(remainingDiskSpace / Adsforce_GIGABYTE);
    NSString *str = [NSString stringWithFormat:@"%lldGB",remainingDiskSpaceGB];
    return str;
}

// 磁盘已使用
+ (NSString *)getDickWithUsed {
    NSDictionary *attrs = [[[NSFileManager alloc] init] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float totalDiskSpace = [[attrs objectForKey:NSFileSystemSize] floatValue];
    unsigned long long totalDiskSpaceGB = (unsigned long long)round(totalDiskSpace / Adsforce_GIGABYTE);
    
    float remainingDiskSpace = [[attrs objectForKey:NSFileSystemFreeSize] floatValue];
    unsigned long long remainingDiskSpaceGB = (unsigned long long)round(remainingDiskSpace / Adsforce_GIGABYTE);
    
    NSString *str = [NSString stringWithFormat:@"%lldGB",totalDiskSpaceGB-remainingDiskSpaceGB];
    return str;
}

// 剩余电量
+ (NSString *)getBatteryWithFree {
    UIDevice * device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = true;
    float level = device.batteryLevel;
    return [NSString stringWithFormat:@"%d", (int)(level * 100 + 0.5)];
}

// 电池状态
+ (NSString *)getBatteryWithState {
    NSString *str;
    
    UIDevice * device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = true;
    UIDeviceBatteryState state = device.batteryState;
    if (state == UIDeviceBatteryStateUnknown) {
        str = @"未知";
    }
    else if (state == UIDeviceBatteryStateUnplugged) {
        str = @"放电";
    }
    else if (state == UIDeviceBatteryStateCharging) {
        str = @"充电";
    }
    else if (state == UIDeviceBatteryStateFull) {
        str = @"满电";
    }
    return str;
}

+ (NSString *)getNetworkStatus {

    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        return @"GPRS";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        return @"2.75G EDGE";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        return @"3G";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        return @"3.5G HSDPA";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        return @"3.5G HSUPA";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        return @"2G";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        return @"3G";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        return @"3G";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        return @"3G";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        return @"HRPD";
    }
    else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        return @"4G";
    }
    else {
        return @"WIFI";
    }
}

#define IOS_CELLULAR    @"pdp_ip0"
//有些分配的地址为en0 有些分配的en1
#define IOS_WIFI2       @"en2"
#define IOS_WIFI1       @"en1"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"  vpn很少用到可以注释
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

+ (NSString *)getIPAddressWithIPV4 {
    return [self getIPAddress:YES];
}

+ (NSString *)getIPAddressWithIPV6 {
    return [self getIPAddress:NO];
}

//获取设备当前网络IP地址（是获取IPv4 还是 IPv6）
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    //从字典中按顺序查询 查询到不为空即停止（顺序为4G(3G)、Wi-Fi、局域网）
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_WIFI2 @"/" IP_ADDR_IPv4, IOS_WIFI1 @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_WIFI2 @"/" IP_ADDR_IPv6, IOS_WIFI1 @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6] ;
 
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
 
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
        {
            address = addresses[key];
            if(address) *stop = YES;
        } ];
    return address ? address : @"0.0.0.0";
}
 
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
 
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// 是否可以使用IDFA
+ (BOOL)canUseIDFA {
    
    // ios 14处理
    if (@available(iOS 14.0, *)) {
        NSInteger s = [XYManager a];
        if (s == 0) {
            // 未提示用户
            return NO;
        }
        else if (s == 1) {
            // 限制使用
            return NO;
        }
        else if (s == 2) {
            // 拒绝
            return NO;
        }
        else if (s == 3) {
            return YES;
        }
        
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        if ([idfa isEqualToString:XY_ZeroIdfa]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    
    if (@available(iOS 10.0, *)) {
        BOOL canUseIDFA = [ASIdentifierManager sharedManager].advertisingTrackingEnabled;   //如果返回的YES说明没有 “开启限制广告跟踪”，可以获取到正确的idfa  如果返回的是NO，说明等待你的就是00000000-0000-0000-0000-000000000000
        return canUseIDFA;
    }
    
    return YES;
}

+ (NSString *)idfa {
    
    // iOS 10以下关闭广告追踪，也可以正常获取到IDFA
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}

+ (NSString *)idfv {
    NSString *str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return str;
}

@end
