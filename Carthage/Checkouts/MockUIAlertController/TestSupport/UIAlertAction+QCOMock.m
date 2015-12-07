//  MockUIAlertController by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "UIAlertAction+QCOMock.h"

#import "NSObject+QCOMockAlerts.h"
#import <objc/runtime.h>


@implementation UIAlertAction (QCOMock)

+ (void)qcoMock_swizzle
{
    [self qcoMockAlerts_replaceClassMethod:@selector(actionWithTitle:style:handler:)
                                withMethod:@selector(qcoMock_actionWithTitle:style:handler:)];
}

+ (instancetype)qcoMock_actionWithTitle:(NSString *)title
                                  style:(UIAlertActionStyle)style
                                handler:(void (^)(UIAlertAction *action))handler
{
    UIAlertAction *action = [self qcoMock_actionWithTitle:title style:style handler:handler];
    objc_setAssociatedObject(action, @selector(qcoMock_handler), handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return action;
}

- (void (^)(UIAlertAction *action))qcoMock_handler
{
    return objc_getAssociatedObject(self, @selector(qcoMock_handler));
}

@end
