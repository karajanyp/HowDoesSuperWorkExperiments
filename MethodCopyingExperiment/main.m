//
//  main.m
//  MethodCopyingExperiment
//
//  Created by Karol Kozub on 13/01/15.
//  Copyright (c) 2015 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

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

@interface X (CopiedMethods)
- (void)xyz;
@end

@implementation X
+ (void)load
{
  Method method = class_getInstanceMethod([C class], @selector(abc));
  IMP imp = method_getImplementation(method);
  const char *typeEncoding = method_getTypeEncoding(method);
  class_addMethod(self, @selector(xyz), imp, typeEncoding);
}
@end

int main(int argc, char *argv[])
{
  @autoreleasepool {
    [[X new] xyz];
  }
}