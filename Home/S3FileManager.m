//
//  S3FileManager.m
//  S3FileBrowser
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 15/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

#import "S3FileManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation S3FileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.path = [S3FileManager applicationDocumentsDirectory];
    }
    return self;
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSArray *)filesAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

- (NSString *)pathForFile:(NSString *)file {
    return [self.path.path stringByAppendingPathComponent:file];
}

- (NSDictionary *)attributesForFile: (NSString *)file {
    NSError* error;
    NSString *path = [self pathForFile:file];
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:path error: &error];
    
    return fileDictionary;
}

#pragma mark - FileTypes

- (BOOL)fileIsDirectory:(NSString *)file {
    BOOL isdir = NO;
    NSString *path = [self pathForFile:file];
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir];
    
    return isdir;
}

+ (BOOL)fileIsPlist:(NSString *)file {
    return [[file.lowercaseString pathExtension] isEqualToString:@"plist"];
}

+ (BOOL)fileIsImage: (NSString *)file {
    NSString *ext = [[file pathExtension] lowercaseString];
    
    return ([ext isEqualToString:@"png"] || [ext isEqualToString:@"jpg"]);
}

+ (BOOL)fileIsVideo: (NSString *)file {
    NSString *ext = [[file pathExtension] lowercaseString];
    
    return ([ext isEqualToString:@"mov"] || [ext isEqualToString:@"mp4"]);
}

- (S3FileBrowserFileType)typeOfFile: (NSString *)file {
    
    if ([self fileIsDirectory:file])
    {
        return S3FileBrowserFileTypeDirectory;
    }
    else if ([S3FileManager fileIsImage: file])
    {
        return S3FileBrowserFileTypeImage;
    }
    else if ([S3FileManager fileIsPlist:file])
    {
        return S3FileBrowserFileTypePlist;
    }
    else if ([S3FileManager fileIsVideo:file])
    {
        return S3FileBrowserFileTypeVideo;
    }
    
    return S3FileBrowserFileTypeOther;
}

#pragma mark - FileManipulation

+ (void)saveDictionary: (NSDictionary *)dictionary toPath: (NSString *)path {
    NSString *json = [S3FileManager jsonStringFromDictionary:dictionary];
    NSError *error;
    
    // create directory if it does not already exist
//    NSError *error;
    NSString *directoryPath = [path stringByDeletingLastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

+ (NSString *)jsonStringFromDictionary: (NSDictionary *)dictionary {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

+ (void)saveImage: (UIImage *)image toPath: (NSString *)path {
    NSString *file = [path lastPathComponent];
    NSString *ext = [[file pathExtension] lowercaseString];
    
    // create directory if it does not already exist
    NSError *error;
    NSString *directoryPath = [path stringByDeletingLastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSData *imageData;
    
    if ([ext isEqualToString:@"png"]) {
        imageData = UIImagePNGRepresentation(image);
    }
    else if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"])
    {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    [imageData writeToFile:path atomically:YES];
}

+ (UIImage *)generateThumbImage : (NSString *)filepath
{
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}


@end
