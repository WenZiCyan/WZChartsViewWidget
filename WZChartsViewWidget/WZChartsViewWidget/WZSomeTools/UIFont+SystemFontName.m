//
//  UIFont+SystemFontName.m
//  WenZiCyan
//
//  Created by 方静雯 on 2018/10/31.
//  Copyright © 2018 WenZiCyan. All rights reserved.
//

#import "UIFont+SystemFontName.h"
#import <objc/runtime.h>

@implementation UIFont (SystemFontName)

+ (void)load{
    SEL origSel1 = @selector(systemFontOfSize:);
    SEL swizSel1 = @selector(suspend_systemFontOfSize:);
    [UIFont swizzleMethods:object_getClass([UIFont class]) originalSelector:origSel1 swizzledSelector:swizSel1];
    
    SEL origSel2 = @selector(boldSystemFontOfSize:);
    SEL swizSel2 = @selector(suspend_boldSystemFontOfSize:);
    [UIFont swizzleMethods:object_getClass([UIFont class]) originalSelector:origSel2 swizzledSelector:swizSel2];
}

+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel{
    //得到类的实例方法
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    //class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        //origMethod and swizMethod already exist
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

+ (UIFont *)suspend_systemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    if (!font){
        return [self suspend_systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)suspend_boldSystemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    if (!font){
        return [self suspend_boldSystemFontOfSize:fontSize];
    }
    return font;
}

@end

