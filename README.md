
#强制NSLocalizedString使用特定语言
##NSLocalizedString宏定义
###一个基本宏和三个变体宏。不过他们最终都会调用`NSBundle`的`localizedStringForKey: value: table: `函数来完成任务。

```oc
#define NSLocalizedString(key, comment) \
	    [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
	    
#define NSLocalizedStringFromTable(key, tbl, comment) \
	    [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:(tbl)]
	    
#define NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
	    [bundle localizedStringForKey:(key) value:@"" table:(tbl)]
	    
#define NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
	    [bundle localizedStringForKey:(key) value:(val) table:(tbl)]
```

- key: 代表从 `Localizable.strings`这个文件中读取对应的 key-value值。
- comment: 一般为 `nil`,也可以是对 `key` 的注释。

##先让我们来看一下国际化的效果！

##配置国际化基础工作
####我们通过一个Localizable.strings文件来存储每个语言的文本，它是iOS默认加载的文件，如果想用自定义名称命名，在使用NSLocalizedString方法时指定tableName为自定义名称就可以了。

￼

##切换语言
应用启动时，首先会读取`NSUserDefaults`中的key为`Languages`的内容，该`key`返回一个`preferredLanguages`数组，存储着`APP`支持的语言列表，数组的第一项为APP当前默认的语言，语言会根据系统的设定而变化，即英文系统就存储英文（en） **PS：（中文简体 = zh-Hans、法语 = fr、etc...）**
那么要实现语言切换，即改变`AppleLanguages`的值即可，我们可以通过`NSUserDefaults`手动去操作，但`AppleLanguages`的值改变后APP得重新启动后才会生效（此时才会读取相应语言的lproj中的资源，意义着就算你改了，资源还是加载的APP启动时lproj中的资源）
```oc
    //获取当前系统语言并设置首次使用哪个语言文件(假设只有两种语言包)
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Language"]) {
        if([currentLanguage hasPrefix:@"zh-Hans"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"Language"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"Language"];
        }
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] hasPrefix:@"zh-Hans"]) {
            [NSBundle setLanguage:@"zh-Hans"];
        }else {
            [NSBundle setLanguage:@"en"];
        }
    }
```
##关键：如何改变**`Languages`**的值加载相应语言的**lproj**资源
我们要知道APP中的图片与字符串的加载，甚至`Storyboard`上的加载都是在 `NSBundle.mainBundle` 上操作的，那么我们只要在语言切换后把 `NSBundle.mainBundle` 替换成当前语言的`bundle`就行了，这样系统通过 `NSBundle.mainBundle` 去加载资源时实则是加载的当前语言 `bundle` 中的资源!

###如何替换呢？
####利用 NSBundle扩展，重写 `-(NSString*)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName` 方法。
这就是**国际化-内置语言切换**的核心所在！
```oc
/**
 修改NSBundle类名 :BundleNew
 */
static const char routeBundle=0;

@interface BundleNew : NSBundle
@end

@implementation BundleNew
-(NSString*)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle* bundle = objc_getAssociatedObject(self, &routeBundle);
//    NSLog(@"%@\n",objc_getAssociatedObject(self, &routeBundle));
    //绑定语言包加载路径
    return bundle ? [bundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}
@end

@implementation NSBundle (Language)
+(void)setLanguage:(NSString*)language
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
```
