//
//  NSBundle+Language.m
//  Internationalization
//
//  Created by lyl on 2017/2/22.
//  Copyright © 2017年 lyl. All rights reserved.
//

#import "NSBundle+Language.h"

#import <objc/runtime.h>

/**
 修改NSBundle类名 :BundleNew
 */
static const char routeBundle=0;

@interface BundleNew : NSBundle
@end

@implementation BundleNew
- (NSString*)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle* bundle = objc_getAssociatedObject(self, &routeBundle);
//    NSLog(@"%@\n",objc_getAssociatedObject(self, &routeBundle));
    //绑定语言包加载路径
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}
@end

@implementation NSBundle (Language)
+ (void)setLanguage:(NSString*)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      object_setClass([NSBundle mainBundle],[BundleNew class]);
                  });
    objc_setAssociatedObject([NSBundle mainBundle], &routeBundle, language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    /*
     利用runtime 动态关联对象
     OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     
     id object ： 源对象 -指定我们需要绑定的对象，e.g ,给一个字符串添加一个内容
     const void * key ： 设置一个静态常亮，也就是Key 值，通过这个我们可以找到我们关联对象的那个数据值
     id value: 这个是我们打点调用属性的时候会自动调用set方法进行传值
     objc_AssociationPolicy policy ： 这个是关联策略，这几个管理策略，我们看下都有什么，
     
     */
}

+ (NSString *)getLanguage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      object_setClass([NSBundle mainBundle],[BundleNew class]);
                  });
    
    NSString * languageStr = objc_getAssociatedObject([NSBundle mainBundle], &routeBundle);
    
    NSLog(@"%@",languageStr);
    
    return languageStr;
    
}

@end
