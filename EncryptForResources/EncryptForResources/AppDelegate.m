//
//  AppDelegate.m
//  EncryptForResources
//
//  Created by Jiang Jacob on 3/6/14.
//  Copyright (c) 2014 Jiang Jacob. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+Base64.h"
#import "FBEncryptorAES.h"

#define AES_KEY         @"abcde=-0987654321"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *keyString=AES_KEY;
    self.keyData=[keyString dataUsingEncoding:NSUTF8StringEncoding];
    // Insert code here to initialize your application
}

- (IBAction)chooseFolder:(id)sender {
    NSOpenPanel *gitDir = [NSOpenPanel openPanel];
    [gitDir setCanChooseDirectories:YES]; //可以打开目录
	[gitDir setCanChooseFiles:NO]; //不能打开文件(我需要处理一个目录内的所有文件)
	[gitDir setDirectory:NSHomeDirectory()]; //起始目录为Home
    if ([gitDir runModal] == NSOKButton) {  //如果用户点OK
        NSString *Directory = [gitDir directory];
        [self encryptAllResources:Directory];
	}
    
    
}

-(void)encryptAllResources:(NSString *)folderPath
{
    NSTask *task=[[NSTask alloc]init];
    [task setLaunchPath:@"/usr/bin/find"];
    NSArray *argvals = [NSArray arrayWithObjects:folderPath, @"-type",@"f",nil];
    [task setArguments: argvals];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    [task launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog(@"遍历文件结果 %@",string);
    NSArray *result=[string componentsSeparatedByString:@"\n"];
    for (NSString *path in result) {
        [self encryptFileAtPath:path];
    }
    NSAlert *alert=[[NSAlert alloc]init];
    alert.messageText=@"done!";
    [alert runModal];
}

-(void)encryptFileAtPath:(NSString *)filePath
{
    NSData *fileData=[NSData dataWithContentsOfFile:filePath];
    NSData *ivData=[FBEncryptorAES generateIv];
    NSData *encryptedData=[FBEncryptorAES encryptData:fileData key:self.keyData iv:ivData];
    NSString *destinyPath=[filePath stringByAppendingString:@".md5"];
    [encryptedData writeToFile:destinyPath atomically:YES];
}

@end
