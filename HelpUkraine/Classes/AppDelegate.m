//
//  AppDelegate.m
//  HelpUkraine
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PushViewController.h"
#import "SendHelpViewController.h"
#import "Constants.h"
#import "Fabric/Fabric.h"
#import "Crashlytics/Crashlytics.h"
#import <sys/utsname.h>
#import "GAI.h"
#import "SSZipArchive.h"

@implementation AppDelegate

NSInteger _lang;
NSString *_previousViewControllerName;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize window
    self.window = [[UIWindow alloc] initWithFrame:_bounds];
    
    // White status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // First start vs Regular start
    if ([_userDefaults objectForKey:@"_firstStart"] != nil)
    {
        // Update plist
        [self downloadDict];
        
        // This is a Regular start
        #ifdef DEBUG
        NSLog(@"This is a Regular start");
        #endif
        
        // Getting app language from the app's settings
        _lang = [_userDefaults integerForKey:@"_lang"];
        
        // Collect APNS and send device info data
        [self collectAPNSandSendData];
        
        // Adding observers to NotificationCenter
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(downloadDict) name: @"downloadDict" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(collectAPNSandSendData) name: @"collectAPNSandSendDatas" object: nil];
        
        // Launching directly to the app
        UINavigationController *_navController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
        //[_navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //[_navController.navigationBar setBackgroundColor:UIColorFromRGB(0x5590a5)];
        //_navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        _navController.navigationBar.shadowImage = [UIImage new];
        _navController.navigationBar.translucent = YES;
        //_navController.navigationBar.barTintColor = UIColorFromRGB(0x5590a5);
        //_navController.navigationBar.tintColor = [UIColor whiteColor];
        [_navController setNavigationBarHidden:YES];
        self.window.rootViewController = _navController;
        [self.window makeKeyAndVisible];
    }
    else
    {
        // Initial plist copy to Application Support folder
        [self initialFileCopy];
        
        // Update dict
        [self downloadDict];
        
        // This is a First start
        #ifdef DEBUG
        NSLog(@"This is a First start");
        #endif
        
        // Setting app's language for the first time depending on the sys localization
        NSString *_sysLang = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        if ([_sysLang isEqualToString:@"en"]) {
            _lang = 0;
        } else if ([_sysLang isEqualToString:@"ru"]) {
            _lang = 1;
        } else if ([_sysLang isEqualToString:@"uk"]) {
            _lang = 2;
        } else
            _lang = 0;
        [_userDefaults setObject:[NSArray arrayWithObject:_sysLang] forKey:@"AppleLanguages"]; //
        [_userDefaults setInteger:_lang forKey:@"_lang"];
        
        // No more first start after this
        [_userDefaults setInteger:1 forKey:@"_firstStart"];
        
        // We assume the pushes would not be enabled
        [_userDefaults setInteger:0 forKey:@"_wasPromptedForPushNotifications"];
        [_userDefaults synchronize];
        
        // Adding observers to NotificationCenter
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(downloadDict) name: @"downloadDict" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(collectAPNSandSendData) name: @"collectAPNSandSendData" object: nil];
        
        // Launching 'agree to pushes' ViewController
        self.window.rootViewController = _pushViewController;
        [self.window makeKeyAndVisible];
    }
    
    // Initialize Crashlytics
    [Fabric with: @[CrashlyticsKit]];
    
    // Initialize Google Analytics
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-58037365-1"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // Enable IDFA collection.
    tracker.allowIDFACollection = YES;
    
    return YES;
}


// Initial file copy to the project
- (void)initialFileCopy
{
    // File paths initialization
    #ifdef DEBUG
    NSLog(@"Initial file copy");
    #endif
    NSBundle *_thisBundle = [NSBundle mainBundle];
    NSFileManager *_fileManager = [[NSFileManager alloc] init];
    
    // Check if Application Support folder is created and create if it's not created
    if ([_fileManager fileExistsAtPath:_ASPath] == NO)
        [_fileManager createDirectoryAtPath:_ASPath withIntermediateDirectories:YES attributes:nil error:nil];
    [_fileManager copyItemAtPath:[_thisBundle pathForResource:@"dict" ofType:@"zip"] toPath:_zipFilePath error:NULL];
    [_fileManager copyItemAtPath:[_thisBundle pathForResource:@"plist" ofType:@"plist"] toPath:_plistFilePath error:NULL];
    [_fileManager copyItemAtPath:[_thisBundle pathForResource:@"aboutus" ofType:@"html"] toPath:_aboutusFilePath error:NULL];
    [SSZipArchive unzipFileAtPath:_zipFilePath toDestination:_ASPath];
    
    // Saving current plist.plist date and version
    [self updateCurrentPlistVersion];
    
    // And counting new organization for the first time
    [self countNewArrivals];
}


// Download dict.plist database
- (void)downloadDict
{
    // Launching a separate thread to free up the UI
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        // Updating current organization count in case there are new arrivals
        [self updateOrganizationAmount];
        
        // Check if newer plist and dict is available
        if ([self newerDictAvailable] == YES)
        {
            #ifdef DEBUG
            NSLog(@"Newer dict available");
            NSLog(@"Updated dict download started");
            #endif
            
            // Starting download
            NSURL *_url = [NSURL URLWithString:_webFileZip];
            NSData *_urlData = [NSData dataWithContentsOfURL:_url];
            if (_urlData)
            {
                #ifdef DEBUG
                NSLog(@"dict path = %@", _zipFilePath);
                #endif
                
                // Writing dict to disk in a separate thread as well
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [_urlData writeToFile:_zipFilePath atomically:YES];
                    [SSZipArchive unzipFileAtPath:_zipFilePath toDestination:_ASPath];
                    #ifdef DEBUG
                    NSLog(@"Updated dict saved");
                    NSLog(@"Data reloaded");
                    #endif
                    [self countNewArrivals];
                    
                });
            }
            #ifdef DEBUG
            else NSLog(@"Updated dict download failure");
            #endif
        }
        #ifdef DEBUG
        else NSLog(@"Dict is up-to-date");
        #endif
        
        // In case downloadDict was called in the Settings view we send a notification to stop the animation there
        [[NSNotificationCenter defaultCenter] postNotificationName: @"databaseStopUpdating" object: nil];
    });
}

// Check if newer plist is available
- (BOOL)newerDictAvailable
{
    BOOL _available = NO;
    [self downloadPlist];
    #ifdef DEBUG
    NSLog(@"Current plist ver = %d", (int)_currentPlistVersion);
    NSLog(@"New plist ver = %d", (int)_newPlistVersion);
    #endif
    if (_newPlistVersion > _currentPlistVersion)
    {
        _available = YES;
        [self updateCurrentPlistVersion];
    }
    #ifdef DEBUG
    else NSLog(@"Plist is up-to-date");
    #endif
    return _available;
}

// Download plist.plist with dict version and date
- (void)downloadPlist
{
    if ([self isThereInternet] == YES)
    {
        #ifdef DEBUG
        NSLog(@"Connected to plist");
        NSLog(@"Plist download started");
        #endif
        
        // Starting download
        NSURL *_url = [NSURL URLWithString:_webFilePlist];
        NSData *_urlData = [NSData dataWithContentsOfURL:_url];
        if (_urlData)
        {
            [_urlData writeToFile:_plistFilePath atomically:YES];
            #ifdef DEBUG
            NSLog(@"Plist succesfully saved");
            #endif
            NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
            [_dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [_dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [_userDefaults setObject:_newPlistDate forKey:@"_newPlistDate"];
            [_userDefaults setInteger: _newPlistVersion forKey:@"_newPlistVersion"];
            [_userDefaults synchronize];
        }
    }
    else {
        #ifdef DEBUG
        NSLog(@"No connection to plist");
        #endif
        [self updateCurrentPlistVersion];
        
    }
}

// Check for internet connection
- (BOOL)isThereInternet
{
    Reachability *_reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus _networkStatus = [_reachability currentReachabilityStatus];
    return _networkStatus != NotReachable;
}

// Update current plist version
- (void)updateCurrentPlistVersion
{
    NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [_dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [_userDefaults setObject:_newPlistDate forKey:@"_currentPlistDate"];
    [_userDefaults setInteger: _newPlistVersion forKey:@"_currentPlistVersion"];
    [_userDefaults synchronize];
    #ifdef DEBUG
    NSLog(@"Updated currentPlistVersion");
    #endif
}

// Count current organizations amount
- (void)updateOrganizationAmount
{
    NSMutableArray *_organizationsAmount = [[NSMutableArray alloc] init];
    [_organizationsAmount addObject:[NSNumber numberWithInteger:[_dictData[15] count]]];
    [_organizationsAmount addObject:[NSNumber numberWithInteger:[_dictData[16] count]]];
    [_organizationsAmount addObject:[NSNumber numberWithInteger:[_dictData[17] count]]];
    [_userDefaults setObject:_organizationsAmount forKey:@"_organizationsAmount"];
    [_userDefaults synchronize];
}

// Count new organizations in an updated dict
- (void)countNewArrivals
{
    NSMutableArray *_newArrivalsAmount = [[NSMutableArray alloc] init];
    [_newArrivalsAmount addObject:[NSNumber numberWithInteger:[_dictData[15] count]]];
    [_newArrivalsAmount addObject:[NSNumber numberWithInteger:[_dictData[16] count]]];
    [_newArrivalsAmount addObject:[NSNumber numberWithInteger:[_dictData[17] count]]];
    [_userDefaults setObject:_newArrivalsAmount forKey:@"_newArrivalsAmount"];
    [_userDefaults synchronize];
}

// Collecting APNS token if possible
- (void)collectAPNSandSendData
{
    if ([self checkIfNotificationsAreEnabled] == YES)
    {
        [self registerForPushNotifications];
    }
    else
    {
        _apnsToken = @"PushDisabled";
        [self sendData];
    }
}

// Send device data to remote server
- (void)sendData
{
    // Launching a separate thread to free up the UI
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        // Collecting device data
        NSString *_sysLang = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        NSString *_iosVersion = [[UIDevice currentDevice] systemVersion];
        NSString *_appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString *_deviceType = [[UIDevice currentDevice] model];
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *_deviceModel = [self platformType:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
        NSString *_deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        // Building up an request
        NSString *_requestString = [NSString stringWithFormat:@"language=%@&ios_version=%@&app_version=%@&device_type=%@&device_model=%@&device_id=%@&token=%@", _sysLang, _iosVersion, _appVersion, _deviceType, _deviceModel, _deviceID, _apnsToken ];
        NSData *_requestData = [_requestString dataUsingEncoding: NSUTF8StringEncoding];
        NSMutableURLRequest *_request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: _webFileDataPhp ] ];
        [_request setHTTPMethod: @"POST"];
        [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [_request setHTTPBody: _requestData];
        [_request setTimeoutInterval:5.0];
        NSURLResponse *_response;
        NSError *_err;
        
        // Initializing the request
        NSData *_returnData = [ NSURLConnection sendSynchronousRequest: _request returningResponse:&_response error:&_err];
        _responseBody = [[NSString alloc] initWithData:_returnData encoding:NSUTF8StringEncoding];
        #ifdef DEBUG
        NSLog(@"Data sent. PHP Answer: %@", _responseBody);
        #endif
    });
}

// Check if notifications are enabled
- (BOOL)checkIfNotificationsAreEnabled
{
    // We assume pushes are disabled
    BOOL _pushesEnabled;
    // iOS 8 check
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        _pushesEnabled = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
    else
        // iOS 7 check
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        _pushesEnabled = (types & UIRemoteNotificationTypeAlert);
    }
    
    return _pushesEnabled;
}


// Get device token
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *_deviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *_deviceTokenCut = [_deviceToken substringWithRange:NSMakeRange(1, _deviceToken.length -2)];
    _apnsToken = [_deviceTokenCut stringByReplacingOccurrencesOfString:@" " withString:@""];
    #ifdef DEBUG
    NSLog(@"Device Token = %@", _apnsToken);
    #endif
    [self sendData];
}

// Get APNS error
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    _apnsToken = [NSString stringWithFormat:@"PushError"];
    #ifdef DEBUG
    NSLog(@"APNS Error = %@", err);
    #endif
    [self sendData];
}

// Register for push notifications
- (void)registerForPushNotifications
{
    // In Simulator
    #if TARGET_IPHONE_SIMULATOR
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // iOS 8
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Register for push"
                                                         message:@"ios8."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [_alert show];
    } else {
        // iOS 7
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Register for push"
                                                         message:@"ios7."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [_alert show];
    }
    // On device
    #elif TARGET_OS_IPHONE
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // iOS 8
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // iOS 7
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    #endif
}

// Device type names
- (NSString *) platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
