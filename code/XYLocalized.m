//
//  XYLocalized.m
//  AASAccountSDK
//
//  Created by steve on 2019/1/18.
//  Copyright © 2019  Technology Co.,Ltd. All rights reserved.
//

#import "XYLocalized.h"

@implementation XYLocalized

+ (NSString *)localizedString:(NSString *)key {
    
    NSString *filePath = [NSString stringWithFormat:@"%@/strings",[[NSBundle mainBundle] pathForResource:@"XYDeviceInfo" ofType:@"bundle"]];
    NSBundle *bundle = [NSBundle bundleWithPath:filePath];
    NSString *str = NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, nil);
    return str;
}

@end
