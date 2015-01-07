//
//  AppDelegate.h
//  HelpUkraine
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Reachability.h"

// Global variables
extern NSInteger _lang;
extern NSString *_previousViewControllerName;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDelegate>
{
    // APNS token
    NSString *_apnsToken;
    
    // PHP response
    NSString *_responseBody;
}

@property (strong, nonatomic) UIWindow *window;

- (void)downloadDict;
- (void)collectAPNSandSendData;
- (void)registerForPushNotifications;
- (BOOL)isThereInternet;
- (BOOL)checkIfNotificationsAreEnabled;

@end
