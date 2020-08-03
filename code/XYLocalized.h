//
//  XYLocalized.h
//  AccountSDK
//
//  Created by steve on 2019/1/18.
//  Copyright © 2019  Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYLocalizedString(key) [XYLocalized localizedString:key]

NS_ASSUME_NONNULL_BEGIN

@interface XYLocalized : NSObject

+ (NSString *)localizedString:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
