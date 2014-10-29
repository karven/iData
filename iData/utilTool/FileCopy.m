//
//  FileCopy.m
//  iData
//
//  Created by karven on 10/14/14.
//  Copyright (c) 2014 karven. All rights reserved.
//

#import "FileCopy.h"

@implementation FileCopy

//+(void)copyFile:(NSString *)srcPath fileName:(NSString *)fileName toPath:(NSString *)dstPath{
//在已知是文件夹的情况下进行复制文件
+(void)copyFile:(NSString *)srcPath toPath:(NSString *)dstPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    /*
    NSString *dPath = [dstPath stringByAppendingString:fileName];
    BOOL isExist = [fileManager fileExistsAtPath:dPath];
    if (isExist) {
        
    }else{
        [fileManager copyItemAtPath:srcPath toPath:dPath error:nil];
        NSArray *srcFileArray = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
        for (NSString *name in srcFileArray) {
            NSString *srcFilePath = [NSString stringWithFormat:@"%@/%@",srcPath,name];
            NSString *dstFilePath = [NSString stringWithFormat:@"%@%@/",dstPath,name];
            NSDictionary *srcInfo = [fileManager attributesOfItemAtPath:srcFilePath error:nil];
            NSString *fileType = [srcInfo objectForKey:@"NSFileType"];
            if ([fileType isEqualToString:@"NSFileTypeDirectory"]) {
                [self copyFile:srcFilePath fileName:name toPath:dstFilePath];
            }else{
                [fileManager copyItemAtPath:srcPath toPath:[dstFilePath substringToIndex:dstFilePath.length-1] error:nil];
            }
        }
    }
    return;
*/
    NSArray *srcArray = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    NSArray *dstArray = [fileManager contentsOfDirectoryAtPath:dstPath error:nil];
    for (NSString *fileName in srcArray) {
        //具体文件路径
        NSString *srcFilePath = [NSString stringWithFormat:@"%@/%@",srcPath,fileName];
        NSString *dstFilePath = [NSString stringWithFormat:@"%@/%@",dstPath,fileName];
        //目标文件夹中存在同名文件，否则……
        
        //查看fileName的文件属性，看是文件夹还是文件
        NSDictionary *srcInfo = [fileManager attributesOfItemAtPath:srcFilePath error:nil];
        NSString *nsFileType = [srcInfo objectForKey:@"NSFileType"];
        if ([dstArray containsObject:fileName]) {
            //如果是文件夹则进行递归
            if ([nsFileType isEqualToString:@"NSFileTypeDirectory"]) {
                [self copyFile:srcFilePath toPath:dstFilePath];
            }else{
                //删除同名的文件，然后拷贝
                [fileManager removeItemAtPath:dstFilePath error:nil];
                [fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
            }
        }else{
            //copyItemAtPath可以直接复制文件夹及其中的文件
            [fileManager copyItemAtPath:srcFilePath toPath:dstFilePath error:nil];
        }
    }
}

+(void)copyRemoteFile:(NSString *)remotePath withRemoteDir:(NSString *)name withDstPath:(NSString *)dstPath{
    NSString *serverPath = [NSString stringWithFormat:@"%@%@/",remotePath,name];
    [kFMServer setDestination:serverPath];
    NSString *localPath = [NSString stringWithFormat:@"%@%@/",dstPath,name];
    [[NSFileManager defaultManager] createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray *array = [kFTPManager contentsOfServer:kFMServer];
    for (NSDictionary *dic in array) {
        NSString *fileType = [dic objectForKey:@"kCFFTPResourceType"];
        NSString *fileName = [dic objectForKey:@"kCFFTPResourceName"];
        if ([fileType intValue]==4) {
            [self copyRemoteFile:serverPath withRemoteDir:fileName withDstPath:localPath];
        }else{
            NSURL *url = [NSURL URLWithString:[localPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            BOOL isSuccess = [kFTPManager downloadFile:fileName toDirectory:url fromServer:kFMServer];
            if (!isSuccess) {
                NSLog(@"%@ 文件下载失败",fileName);
            }
        }
    }
}

@end
