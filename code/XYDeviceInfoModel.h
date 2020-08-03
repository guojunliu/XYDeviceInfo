//
//  XYDeviceInfoModel.h
//  XYDeviceInfo
//
//  Created by steve on 2020/7/28.
//

#import <Foundation/Foundation.h>

@interface XYDeviceInfoModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic) BOOL check;

+ (NSMutableArray *)getInfoArray;

+ (NSMutableArray *)getSystemInfoArray;

+ (NSMutableArray *)getScreenInfoArray;

+ (NSMutableArray *)getCPUInfoArray;

+ (NSMutableArray *)getMemoryInfoArray;

+ (NSMutableArray *)getDiskInfoArray;

+ (NSMutableArray *)getBatteryInfoArray;

+ (NSMutableArray *)getNetworkInfoArray;

+ (NSMutableArray *)getAdInfoArray;

@end
