//
//  Constants.h
//  HelpUkraine
//
//  Created by Admin on 10/18/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

// Macro for getting RGB UIColor from hex color palette
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// Macro for defining iPhones
#define _iPhone5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define _iPhone4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
#define _iPhone6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < DBL_EPSILON)
#define _iPhone6Plus (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < DBL_EPSILON)

// Macro for checking iOS version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Macro for getting device's status bar and navigation bar height and the bounds of the screen
#define _statusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define _navigationBarHeight self.navigationController.navigationBar.frame.size.height
#define _bounds [[UIScreen mainScreen] bounds]

// Macro for accessing all the View Controllers
#define _appDelegate (AppDelegate *)[[UIApplication sharedApplication]delegate]
#define _pushViewController [[PushViewController alloc] init]
#define _mainViewController [[MainViewController alloc] init]
#define _sendHelpViewController [[SendHelpViewController alloc] init]
#define _settingsViewController [[SettingsViewController alloc] init]
#define _listViewController [[ListViewController alloc] init]
#define _detailsViewController [[DetailsViewController alloc] init]
#define _webViewController [[WebViewController alloc] init]
#define _feedbackViewController [[FeedbackViewController alloc] init]

// Macro for accessing user settings and local file and their paths
#define _userDefaults [NSUserDefaults standardUserDefaults]
#define _applicationSupportPath NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)
#define _ASPath [_applicationSupportPath objectAtIndex:0]
#define _zipFilePath [NSString stringWithFormat:@"%@/%@", _ASPath, @"dict.zip"]
#define _dictFilePath [NSString stringWithFormat:@"%@/%@", _ASPath, @"dict.plist"]
#define _plistFilePath [NSString stringWithFormat:@"%@/%@", _ASPath, @"plist.plist"]
#define _aboutusFilePath [NSString stringWithFormat:@"%@/%@", _ASPath, @"aboutus.html"]
#define _plistData [[NSDictionary alloc] initWithContentsOfFile:_plistFilePath]
#define _dictData [[NSMutableArray alloc] initWithContentsOfFile:_dictFilePath]

// Macro for accessing remote files and their paths
#ifdef DEBUG
#define _webFilePrefix @"http://helpua.com.ua/appdata/debug"
#else
#define _webFilePrefix @"http://helpua.com.ua/appdata/production"
#endif
#define _webFileDataPhp [NSString stringWithFormat:@"%@/%@", _webFilePrefix, @"data.php"]
#define _webFilePlist [NSString stringWithFormat:@"%@/%@", _webFilePrefix, @"plist.plist"]
#define _webFileDict [NSString stringWithFormat:@"%@/%@", _webFilePrefix, @"dict.plist"]
#define _webFileZip [NSString stringWithFormat:@"%@/%@", _webFilePrefix, @"dict.zip"]
#define _webFileAboutus [NSString stringWithFormat:@"%@/%@", _webFilePrefix, @"aboutus.html"]
#define _webFileFeedback [NSString stringWithFormat:@"%@/%@", _webFilePrefix, @"feedback/feedback.php"]

// Macro which keeps track on the version and date of the plist
#define _newPlistDate [_dateFormat dateFromString:[_plistData valueForKey:@"plistDate"]]
#define _newPlistVersion [[_plistData valueForKey:@"plistVersion"] integerValue]
#define _currentPlistDate [_userDefaults objectForKey:@"_currentPlistDate"]
#define _currentPlistVersion [_userDefaults integerForKey:@"_currentPlistVersion"]

// Macro which allows getting the number of current and new organizations
#define _totalOrganizations [_userDefaults objectForKey:@"_organizationsAmount"]
#define _newOrganizations [_userDefaults objectForKey:@"_newArrivalsAmount"]

// Macro for SendHelpViewController
#define _sendHelpTableGroupColors [[NSMutableArray alloc] initWithArray:_dictData[0]]
#define _sendHelpTableGroupOrders [[NSMutableArray alloc] initWithArray:_dictData[1]]
#define _sendHelpTableGroupTypes [[NSMutableArray alloc] initWithArray:_dictData[2]]
#define _sendHelpTableGroupTitles [[NSMutableArray alloc] initWithArray:_dictData[_lang+3]]
#define _detailsOrderFromDict _dictData[6]
#define _detailsTitlesFromDict _dictData[_lang+7]
#define _dictInOneLanguage _dictData[15+_lang]

#ifndef HelpUkraine_Constants_h
#define HelpUkraine_Constants_h

#endif
