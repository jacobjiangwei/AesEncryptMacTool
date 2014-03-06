//
//  AppDelegate.h
//  EncryptForResources
//
//  Created by Jiang Jacob on 3/6/14.
//  Copyright (c) 2014 Jiang Jacob. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>



@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong)        NSData *keyData;


- (IBAction)chooseFolder:(id)sender;

@end
