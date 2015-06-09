//
//  S3FileManager.h
//  S3FileBrowser
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 15/05/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, S3FileBrowserFileType) {
    S3FileBrowserFileTypeImage,
    S3FileBrowserFileTypeVideo,
    S3FileBrowserFileTypeText,
    S3FileBrowserFileTypePlist,
    S3FileBrowserFileTypeDirectory,
    S3FileBrowserFileTypeOther
};

@interface S3FileManager : NSObject

@property (strong) NSURL *path;

+ (NSURL *)applicationDocumentsDirectory;
+ (NSArray *)filesAtPath:(NSString *)path;
- (NSString *)pathForFile:(NSString *)file;
- (NSDictionary *)attributesForFile: (NSString *)file;

- (BOOL)fileIsDirectory:(NSString *)file;
+ (BOOL)fileIsPlist:(NSString *)file;
+ (BOOL)fileIsImage: (NSString *)file;
+ (BOOL)fileIsVideo: (NSString *)file;
- (S3FileBrowserFileType)typeOfFile: (NSString *)file;

+ (void)saveDictionary: (NSDictionary *)dictionary toPath: (NSString *)path;
+ (void)saveImage: (UIImage *)image toPath: (NSString *)path;

+ (UIImage *)generateThumbImage : (NSString *)filepath;

@end
