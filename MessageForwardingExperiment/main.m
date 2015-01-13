//
//  main.m
//  MessageForwardingExperiment
//
//  Created by Karol Kozub on 13/01/15.
//  Copyright (c) 2015 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSInvocation (PrivateAPI)
- (void)invokeUsingIMP:(IMP)imp;
@end

@interface A : NSObject @end
@interface B : A @end
@interface C : B @end
@interface X : NSObject @end

@implementation A
- (void)abc
{
  NSLog(@"-[A abc]");
}
@end

@implementation B
@end

@implementation C
- (void)abc
{
  [super abc];
  NSLog(@"-[C abc]");
}
@end

@interface X (ForwardedMethods)
- (void)xyz;
@end

@implementation X
- (BOOL)respondsToSelector:(SEL)selector
{
  return selector == @selector(xyz);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
  if (selector == @selector(xyz)) {
    return [C instanceMethodSignatureForSelector:@selector(abc)];
  }

  return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  if (invocation.selector == @selector(xyz)) {
    Method method = class_getInstanceMethod([C class], @selector(abc));
    [invocation invokeUsingIMP:method_getImplementation(method)];
  }
}
@end

int main(int argc, char *argv[])
{
  @autoreleasepool {
    [[X new] xyz];
  }
}