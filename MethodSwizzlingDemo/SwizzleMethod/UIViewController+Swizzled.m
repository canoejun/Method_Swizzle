//
//  UIViewController+Swizzled.m
//  MethodSwizzlingDemo
//
//  Created by canoejun on 2020/6/13.
//  Copyright © 2020 canoejun. All rights reserved.
//

#import "UIViewController+Swizzled.h"
#import <objc/message.h>

@implementation UIViewController (Swizzled)

+(void)load{
    SEL originSEL = @selector(viewWillAppear:);
    SEL swizzleSEL = @selector(swizzleViewWillAppear:);
    Class class = [self class];
    

    swizzleInstance(class, originSEL, swizzleSEL);
    
}

static void swizzleInstance(Class class,SEL originSEL,SEL swizzleSEL){
    // 如果originalSel没有实现过，class_getInstanceMethod无法找到该方法，所以originalMethod为nil
    Method originMethod = class_getInstanceMethod(class, originSEL);
    Method swizzleMethod = class_getInstanceMethod(class, swizzleSEL);
    
    BOOL didAddMethod = class_addMethod(class, originSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if(didAddMethod){
        //  当originalMethod为nil时，这里的class_replaceMethod将不做替换，所以swizzleSel方法里的实现还是自己原来的实现
        class_replaceMethod(class, swizzleSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

-(void)printCurrentPath{
    UIViewController *parentClass = [self parentViewController];
    NSInteger rank = -1;
    if(parentClass == nil){
        rank = 0;
    }else if ([parentClass isKindOfClass:[UINavigationController class]]){
        rank = 1;
    }else if ([parentClass isKindOfClass:[UITabBarController class]]){
        rank = 2;
    }else if ([parentClass isKindOfClass:[UIPageViewController class]]){
        rank = 3;
    }
    [self logControllerWithController:parentClass rank:rank];
}

-(void)logControllerWithController:(UIViewController *)contrller rank:(NSInteger)rank{
    NSString *paddingItems = @"";
    
//    获取方法列表
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([contrller class], &outCount);
    NSMutableArray<NSString *> *propertyList = [NSMutableArray array];
    for(int i = 0;i < outCount;i++){
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [propertyList addObject:propertyName];
    }
    free(properties);
    
//    判断是否是容器controller
    NSMutableString * logStr = [NSMutableString stringWithString:[NSString stringWithFormat:@" ParentController :%@  subControllers:",[contrller.class description]]];
    if([propertyList containsObject:@"viewControllers"]){
        NSArray *array = objc_msgSend(contrller,sel_registerName("viewControllers"));
        [array enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [logStr appendString:[obj.class description]];
            [logStr appendString:@" & "];
        }];
    }

    switch (rank) {
        case 0:
            NSLog(@"%@ \nCurrenView：%@>> %@",logStr, paddingItems, [self.class description]);
            break;
        case 1:
            NSLog(@"%@ \nCurrenView：%@>> %@",logStr, paddingItems, [self.class description]);
            break;
        case 2:
            NSLog(@"%@ \nCurrenView：%@>> %@",logStr, paddingItems, [self.class description]);
            break;
        case 3:
            NSLog(@"%@ \nCurrenView：%@>> %@",logStr, paddingItems, [self.class description]);
            break;
        default:
            break;
    }
}

-(void)swizzleViewWillAppear:(BOOL)animated{
    [self printCurrentPath];
    [self swizzleViewWillAppear:animated];
}



@end
