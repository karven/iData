//
//  FileCopy.h
//  iData
//
//  Created by karven on 10/14/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPManager.h"

@interface FileCopy : NSObject

//复制文件
+(void)copyFile:(NSString *)srcPath toPath:(NSString *)dstPath;
//+(void)copyFile:(NSString *)srcPath fileName:(NSString *)fileName toPath:(NSString *)dstPath;
//远程文件复制
+(void)copyRemoteFile:(NSString *)remotePath withRemoteDir:(NSString *)name withDstPath:(NSString *)dstPath;

@end
