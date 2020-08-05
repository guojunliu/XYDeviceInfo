//
//  XYATTrackingManager.m
//  XYDeviceInfo
//
//  Created by steve on 2020/8/4.
//

#import "XYATTrackingManager.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation XYATTrackingManager

+ (ATTrackingManagerAuthorizationStatus)trackingAuthorizationStatus {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AppTrackingTransparency.framework"];
    [bundle load];
    Class ATTrackingManager = NSClassFromString(@"ATTrackingManager");
    ATTrackingManagerAuthorizationStatus returnValue = ((int (*)(id, SEL)) objc_msgSend)(ATTrackingManager, _cmd);
    return returnValue;
}

+ (void)requestTrackingAuthorizationWithCompletionHandler:(void(^)(ATTrackingManagerAuthorizationStatus status))completion {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AppTrackingTransparency.framework"];
    [bundle load];
    Class ATTrackingManager = NSClassFromString(@"ATTrackingManager");
    ((void (*)(id, SEL, void(^)(ATTrackingManagerAuthorizationStatus status))) objc_msgSend)(ATTrackingManager, _cmd, completion);
}

@end
