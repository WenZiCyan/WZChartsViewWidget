//
//  UIResponder+Router.m
//  WenZiCyan
//
//  Created by Fangjw on 2018/7/13.
//  Copyright © 2018年 WenZiCyan. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

-(void)routerHeaderEvent:(id)info{
    [self.nextResponder routerHeaderEvent:info];
}

@end
