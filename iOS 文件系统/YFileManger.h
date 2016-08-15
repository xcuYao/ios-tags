//
//  YFileManger.h
//  NewSkyEyes
//
//  Created by yaoning on 16/8/15.
//  Copyright © 2016年 jindidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFileManger : NSObject

YSingletonH(YFileManger)

/**
 *  获取缓存目录文件大小
 *
 *  @return 
 */
- (CGFloat)cacheSize;

/**
 *  缓存文件是否存在
 *
 *  @param key eg. homeNews ()
 *
 *  @return
 */
- (BOOL)isCacheFileExist:(NSString *)cacheKey;
/**
 *  缓存文件
 *
 *  @param data 二进制数据
 *  @param key  cacheKey
 *
 *  @return
 */
- (void)cacheData:(NSData *)data key:(NSString *)key;

/**
 *  通过key获取缓存数据
 *
 *  @param key
 *
 *  @return 若没有则返回nil
 */
- (NSData *)cacheWithKey:(NSString *)key;

/**
 *  文件是否存在
 *
 *  @param path
 *
 *  @return
 */
- (BOOL)isFileExist:(NSString *)path;

/**
 *  文件夹是否存在
 *
 *  @param path
 *
 *  @return
 */
- (BOOL)isDicExist:(NSString *)path;

/**
 *  写入文件
 *
 *  @param path     文件路径
 *  @param contents 内容
 *  @param append   是否追加
 */
- (void)writeFile:(NSString *)path content:(NSData *)contents append:(BOOL)append;

/**
 *  删除文件
 *
 *  @param path 文件目录
 */
- (void)removeFile:(NSString *)path;

@end
