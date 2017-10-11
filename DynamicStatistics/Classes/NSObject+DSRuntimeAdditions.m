//
//  NSObject+DSRuntimeAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "NSObject+DSRuntimeAdditions.h"
#import <objc/runtime.h>

void void_imp(){};

@implementation NSObject (DSRuntimeAdditions)

+ (void)swizzleInstanceSelector:(SEL)originalSelector with:(SEL)swizzledSelector;
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+(void)swizzleClassSelector:(SEL)originalSelector with:(SEL)swizzledSelector
{
    Class class = object_getClass((id)self);
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withIMP:(IMP)swizzledImplementation andTypeEncoding:(const char *)types
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);

    SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(originalSelector)]);

    //以orignial方法名 + swizzled实现 添加 Method
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    swizzledImplementation,
                    types);
    
    //如果添加成功表示，当前类并无original的实现
    if (didAddMethod) {
        if (originalMethod != NULL) {
            //如果父类有original方法的实现，则在当前类添加 swizzled 方法名 + original 实现 的Method
            class_addMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        }else{
            //如果父类也无original方法的实现，那么增加一个空实现，避免“unknown selector”的exception
            //todo:对于有返回值的函数，这里有bug
            class_addMethod(class, swizzledSelector, (IMP)void_imp, "v@:");
        }
    }
    //如果添加失败，那么表示当前类已经有original方法的实现，接下来只需要交换实现即可
    else{
        didAddMethod =
        class_addMethod(class,
                        swizzledSelector,
                        swizzledImplementation,
                        types);
        //为了避免重复交换，当且仅当 当前类无 swizzled方法时，才进行交换实现
        if (didAddMethod) {
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

+(void)swizzleClassSelector:(SEL)originalSelector withIMP:(IMP)swizzledImplementation andTypeEncoding:(const char *)types
{
    Class class = object_getClass((id)self);
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    
    SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(originalSelector)]);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    swizzledImplementation,
                    types);
    
    if (didAddMethod) {
        if (originalMethod != NULL) {
            class_addMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        }else{
            //todo:对于有返回值的函数，这里有bug
            class_addMethod(class, swizzledSelector, (IMP)void_imp, "v@:");
        }
    }else{
        didAddMethod =
        class_addMethod(class,
                        swizzledSelector,
                        swizzledImplementation,
                        types);
        if (didAddMethod) {
            Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }

}

@end
