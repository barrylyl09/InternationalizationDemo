//
//  NSBundle+Language.h
//  Internationalization
//
//  Created by lyl on 2017/2/22.
//  Copyright © 2017年 lyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Language)

+ (void)setLanguage:(NSString*)language;
+ (NSString *)getLanguage;

@end
