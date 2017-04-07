# 数据库Database
包含CJFMDBFileManager和CommonSqliteUtil,可任选其一来操作数据库

## CJFMDBFileManager
实现多数据的管理，不同的CJFMDBFileManager子类管理不同的数据库(原来的CommonFMDBUtil已停止使用)


方法：
两个类的使用精髓，都是注重在编辑sql语句上。
附：
```
CommonSqliteUtil.podspec别忘了加 s.libraries = "sqlite3"
```

``` 
    Readme.md编辑方法：
    ①##是标题，#号的多少表示标题的大小，越多越小
    ②一对```是中间区域加灰色底框，这个常用语突出显示方法实现
    ③一对`也是中间区域加灰色底框，这个常用于突出显示方法名。如:`commonAdView_setImageView: withImagePath:`
    ④一对[]加一对()表示链接名及链接地址，如[CocoaPods](http://cocoapods.org)
    ⑤图片：感叹号!加一对[],加(),()中的内容为图片当前路径，及在网页上鼠标悬停图片上时，显示的名字
        ## Screenshots
        ![Example](./Screens/example.gif "Example View")
        ![Example](./Screens/example.png "Example View")
    ⑥点：一个-开头
``` 

## Example 
``` 
#pragma mark - insert

+ (BOOL)insertInfo:(AccountInfo *)info
{
    NSAssert(info, @"info cannot be nil!");
    
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT OR REPLACE INTO %@ (uid, name, email, pasd, imageName, imageUrl, imagePath, modified, execTypeL) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", kCurrentTableName, info.uid, info.name, info.email, info.pasd, info.imageName, info.imageUrl, info.imagePath, info.modified, info.execTypeL];//DB Error: 1 "unrecognized token: ":"" 即要求插入的字符串需加引号'，而对于表名，属性名，可以不用像原来那样添加。
    
    return [[FirstFMDBFileManager sharedInstance] insert:sql];
}
``` 

``` 
#pragma mark - remove

+ (BOOL)removeInfoWhereName:(NSString *)name
{
    NSAssert(name, @"name cannot be nil!");
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where name = '%@'",kCurrentTableName, name];
    
    return [[FirstFMDBFileManager sharedInstance] remove:sql];
}
``` 

``` 
#pragma mark - update

+ (BOOL)updateInfoExceptUID:(AccountInfo *)info whereUID:(NSString *)uid
{
    NSString *sql = [NSString stringWithFormat:
                           @"UPDATE %@ SET name = '%@', email = '%@', pasd = '%@', imageName = '%@', imageUrl = '%@', imagePath = '%@' WHERE uid = '%@'", kCurrentTableName,
                     info.name, info.email, info.pasd, info.imageName, info.imageUrl, info.imagePath, uid];
    return [[FirstFMDBFileManager sharedInstance] update:sql];
}

+ (BOOL)updateInfoImagePath:(NSString *)imagePath whereUID:(NSString *)uid{
    NSString *sql = [NSString stringWithFormat:
                      @"update %@ set imagePath = '%@' where uid = '%@'", kCurrentTableName, imagePath, uid];
    return [[FirstFMDBFileManager sharedInstance] update:sql];
}


+ (BOOL)updateInfoImageUrl:(NSString *)imageUrl whereUID:(NSString *)uid{
    NSString *sql = [NSString stringWithFormat:
                     @"update %@ set imageUrl = '%@' where uid = '%@'", kCurrentTableName, imageUrl, uid];
    return [[FirstFMDBFileManager sharedInstance] update:sql];
}

+ (BOOL)updateInfoExecTypeL:(NSString *)execTypeL whereUID:(NSString *)uid{
    NSString *sql = [NSString stringWithFormat:
                     @"update %@ set execTypeL = '%@' where uid = '%@'", kCurrentTableName, execTypeL, uid];
    return [[FirstFMDBFileManager sharedInstance] update:sql];
}

``` 

``` 
#pragma mark - query

+ (NSDictionary *)selectInfoWhereUID:(NSString *)uid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where uid = '%@'", kCurrentTableName, uid];
    
    NSArray *result = [[FirstFMDBFileManager sharedInstance] query:sql];
    return result.count > 0 ? result[0] : nil;
}

//为了在登录页面上，输入名字的时候可以显示出已经登录过的头像而加入的方法
+ (UIImage *)selectImageWhereName:(NSString *)name
{
    NSString *sql = [NSString stringWithFormat:@"SELECT imagePath FROM %@ where name = '%@'", kCurrentTableName, name];
    
    NSArray *result = [[FirstFMDBFileManager sharedInstance] query:sql];
    NSString *imagePath = result.count > 0 ?
            [result[0] objectForKey:@"imagePath"] : [[NSBundle mainBundle] pathForResource:@"people_logout" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}

``` 


**More usage reference test case.**

## Attention

Does not support model collections, such as NSArray&lt;User&gt;* users;

## Author

[李xx](http://)

## License

MIT



