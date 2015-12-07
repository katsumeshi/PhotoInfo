//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "NSObject+QCOMockAlerts.h"

#import <objc/runtime.h>


@implementation NSObject (QCOMockAlerts)

+ (void)qcoMockAlerts_replaceClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)qcoMockAlerts_replaceInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
