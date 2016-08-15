//
//  YFileManger.m
//  NewSkyEyes
//
//  Created by yaoning on 16/8/15.
//  Copyright © 2016年 jindidata. All rights reserved.
//

#import "YFileManger.h"

@interface YFileManger()

@property (nonatomic, strong) NSString *cacheDicPath;

@end

@implementation YFileManger

YSingletonM(YFileManger)

- (instancetype)init{
    if (self = [super init]) {
        [self setDefault];
    }
    return self;
}

- (void)setDefault{
    //创建本地缓存目录path
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/YCache",cachePath];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    self.cacheDicPath = path;
}

- (NSString *)cacheFilePath:(NSString *)key{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/YCache/%@",key]];
    return path;
}

#pragma mark Public Method

- (CGFloat)cacheSize{
    if (![self isDicExist:self.cacheDicPath]) {
        return 0;
    }
    NSDictionary *filedic = [[NSFileManager defaultManager] attributesOfItemAtPath:self.cacheDicPath error:nil];
    NSNumber *size = [filedic objectForKey:NSFileSize];
    return [size floatValue]/1000;
}

- (BOOL)isCacheFileExist:(NSString *)cacheKey{
    return [self isFileExist:[self cacheFilePath:cacheKey]];
}

- (void)cacheData:(NSData *)data key:(NSString *)key{
    NSString *path = [self cacheFilePath:key];
    [self writeFile:path content:data append:NO];
}

- (NSData *)cacheWithKey:(NSString *)key{
    NSString *path = [self cacheFilePath:key];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (BOOL)isFileExist:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];;
}

- (BOOL)isDicExist:(NSString *)path{
    BOOL dir = YES;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
}

- (void)writeFile:(NSString *)path content:(NSData *)contents append:(BOOL)append{
    if (![self isFileExist:path]) {
        [self createFileWithPath:path];
    }
    NSFileHandle *handler = [NSFileHandle fileHandleForWritingAtPath:path];
    if (!append) {
        //清空文件
        [handler truncateFileAtOffset:0];
    }
    [handler seekToEndOfFile];
    [handler writeData:contents];
    [handler closeFile];
}

- (void)removeFile:(NSString *)path{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        YTLog(@"remove file error with path:%@", path);
    }
}

#pragma mark Private Method

- (void)createFileWithPath:(NSString *)path{
    [self createFileWithPath:path overwrite:YES];
}

- (void)createFileWithPath:(NSString *)path overwrite:(BOOL)over{
    NSFileManager *manger = [NSFileManager defaultManager];
    if (over || ![manger fileExistsAtPath:path]) {
        [manger createFileAtPath:path contents:nil attributes:nil];
    }
}

@end
