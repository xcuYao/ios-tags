1.沙盒 sandbox

沙盒是iOS设备上每一个App单独存储数据的一个文件夹 它的根目录打印出来类似(.../Containers/Data/Application/DD326C4A-7463-4170-B0F1-6EF02C69AED1)

其中一长串16进制32位的字符串表示当前App的根目录 这个字符串 在App再次启动之后会变更

沙盒根目录下 分别有三个文件夹 

 Documents （存放在App中产生的需要持久保存的数据）

 Library（存储设置和其他状态信息）

 tmp（存储临时文件）

 其中 Documents 和Library会被iTunes同步备份 

 Library/cache 目录通常用来存放缓存

```objc
//获取根目录
NSHomeDirectory();

//获取Document
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
NSString *path = [paths objectAtIndex:0]; 

//获取Library
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);  
NSString *path = [paths objectAtIndex:0]; 

//获取缓存目录
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);  
NSString *path = [paths objectAtIndex:0];

//获取tmp目录
NSTemporaryDirectory();
```

2\. 文件及文件夹的创建 删除 移动 写入 增量写入 大小统计

主要借助NSFileManger这个类

```objc
//创建文件 层级目录不存在则创建失败
- (BOOL)createFileAtPath:(NSString *)path contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr;

//删除文件
- (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error NS_AVAILABLE(10_5, 2_0);

//移动 拷贝 快捷方式文件
- (BOOL)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error NS_AVAILABLE(10_6, 4_0);
- (BOOL)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error NS_AVAILABLE(10_6, 4_0);
- (BOOL)linkItemAtURL:(NSURL *)srcURL toURL:(NSURL *)dstURL error:(NSError **)error NS_AVAILABLE(10_6, 4_0);

//写入文件 
//1.通过NSString NSArray 等对象的方法直接写
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
...
//2.文件创建一并写入 需要编码为NSData 
//借助NSKeyedArchiver 进行归档
+ (NSData *)archivedDataWithRootObject:(id)rootObject;
//3.借助NSFileHandle 实现增量写入
NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:path];
[handler seekToEndOfFile];
[handler writeData:contents];
[handler closeFile];
//offset为0表示移动到最前边 相当于重新写入
- (void)truncateFileAtOffset:(unsigned long long)offset;

//创建文件夹
//createIntermediates 表示是否创建缺失文件夹
- (BOOL)createDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(nullable NSDictionary<NSString *, id> *)attributes error:(NSError **)error NS_AVAILABLE(10_5, 2_0);
//拷贝 移动 删除 类似File

//统计文件大小
NSDictionary *filedic = [[NSFileManager defaultManager] attributesOfItemAtPath:self.cacheDicPath error:nil];
    NSNumber *size = [filedic objectForKey:NSFileSize];

```

