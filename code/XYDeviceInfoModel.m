//
//  XYDeviceInfoModel.m
//  XYDeviceInfo
//
//  Created by steve on 2020/7/28.
//

#import "XYDeviceInfoModel.h"
#import "XYSystemUtil.h"
#import "XYLocalized.h"

@implementation XYDeviceInfoModel

+ (NSMutableArray *)getInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    
    int i = 0;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"设备名称");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDeviceUserName];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"系统版本");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getSystemVersion];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"产品型号");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getIphoenModel];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"系统语言");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getSystemLanguage];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"运营商");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getOperator];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"逻辑分辨率");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getLogicalResolution];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"缩放因子");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getScalingFactor];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"屏幕分辨率");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getResolution];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"CPU架构");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getCPUArchitecture];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"CPU数目");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getCPUNumber];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"CPU使用总比例");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getCPUUsed];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"内存总容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getMemoryWithTotal];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"内存已使用");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getMemoryWithUsed];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"内存剩余容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getMemoryWithFree];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"磁盘总容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDickWithTotal];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"磁盘已使用");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDickWithUsed];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"磁盘剩余容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDickWithFree];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"剩余电量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getBatteryWithFree];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"电池状态");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getBatteryWithState];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"网络状态");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getNetworkStatus];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"IDFA");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil idfa];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"IDFV");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil idfv];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    
    return array;
}

+ (NSMutableArray *)getSystemInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    
    int i = 0;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"设备名称");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDeviceUserName];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"系统版本");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getSystemVersion];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"产品型号");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getIphoenModel];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"系统语言");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getSystemLanguage];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getScreenInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"逻辑分辨率");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getLogicalResolution];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"缩放因子");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getScalingFactor];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"屏幕分辨率");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getResolution];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getCPUInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"CPU架构");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getCPUArchitecture];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"CPU数目");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getCPUNumber];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"CPU使用总比例");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getCPUUsed];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getMemoryInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"内存总容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getMemoryWithTotal];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"内存已使用");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getMemoryWithUsed];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"内存剩余容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getMemoryWithFree];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getDiskInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"磁盘总容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDickWithTotal];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"磁盘已使用");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDickWithUsed];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"磁盘剩余容量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getDickWithFree];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getBatteryInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"剩余电量");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getBatteryWithFree];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"电池状态");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getBatteryWithState];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getNetworkInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"网络状态");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getNetworkStatus];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"运营商");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getOperator];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"IPV4地址");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getIPAddressWithIPV4];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"IPV6地址");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil getIPAddressWithIPV6];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

+ (NSMutableArray *)getAdInfoArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10 ; i++) {
        XYDeviceInfoModel *model = [[XYDeviceInfoModel alloc] init];
        [array addObject:model];
    }
    int i = 0;
    
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"限制广告追踪");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil canUseIDFA]?@"NO":@"YES";
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"IDFA");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil idfa];
    
    i++;
    ((XYDeviceInfoModel *)(array[i])).title = XYLocalizedString(@"IDFV");
    ((XYDeviceInfoModel *)(array[i])).message = [XYSystemUtil idfv];
    
    [array removeObjectsInRange:NSMakeRange(i+1, array.count-(i+1))];
    return array;
}

@end
