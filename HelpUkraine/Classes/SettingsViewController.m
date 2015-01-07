//
//  SettingsViewController.m
//  HelpUkraine
//
//  Created by Admin on 9/13/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "PushViewController.h"
#import "FeedbackViewController.h"
#import "WebViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set grey background and View's title
        self.view.backgroundColor = UIColorFromRGB(0xefeff4);
        self.title = NSLocalizedString(@"settingsViewNavigationTitle", nil);
        
        // Init View
        [self initView];
    }
    return self;
}

- (void)initView
{
    // Initializing Rectangles for the buttons
    float _lineHeight = 44;
    float _navBar = 64;
    float _offset = 15;
    CGRect _generalGroupViewRect = CGRectMake(0, 55 + _navBar, _bounds.size.width, 2 * _lineHeight);
    CGRect _generalGroupLabelRect = CGRectMake(15, 35 + _navBar, _bounds.size.width - _offset, 10);
    CGRect _notificationsLabelRect = CGRectMake(15, 55 + _navBar, _bounds.size.width - _offset, _lineHeight);
    CGRect _notificationsSwitcherRect = CGRectMake(_bounds.size.width - _offset - 51, 62 + _navBar, 51, 31);
    CGRect _horizontalLineRect = CGRectMake(15, 55 + _lineHeight + _navBar, _bounds.size.width - 2 *_offset, 0.5);
    CGRect _languagesLabelRect = CGRectMake(15, 55 + _lineHeight + _navBar, _bounds.size.width - 2 *_offset, _lineHeight);
    CGRect _languagesSwitcherRect = CGRectMake(_bounds.size.width - _offset - 100, 62 + _lineHeight + _navBar, 100, 31);
    CGRect _databaseGroupViewRect = CGRectMake(0, _navBar + 2 * (55 + _lineHeight), _bounds.size.width, _lineHeight);
    CGRect _databaseGroupLabelRect = CGRectMake(15, 35 + _navBar + 55 + 2 * _lineHeight, _bounds.size.width - _offset, 10);
    CGRect _databaseStatusLabelRect = CGRectMake(15, _navBar + 2 * (55 + _lineHeight), _bounds.size.width - _offset, _lineHeight);
    CGRect _reloadDatabaseButtonRect = CGRectMake(_bounds.size.width - _lineHeight, _navBar + 2 * (55 + _lineHeight), _lineHeight, _lineHeight);
    CGRect _infoGroupTableViewRect = CGRectMake(0, _navBar + 3 * (55 + _lineHeight), _bounds.size.width, 2 * _lineHeight);
    CGRect _horizontalLine2Rect = CGRectMake(15, _navBar + 3 * (55 + _lineHeight) + _lineHeight, _bounds.size.width - 2 *_offset, 0.5);
    CGRect _infoGroupLabelRect = CGRectMake(15, _navBar + 2 * 55 + 3 * _lineHeight + 35, _bounds.size.width - _offset, 10);
    
    // General Group View
    _generalGroupView = [[UIView alloc] initWithFrame:_generalGroupViewRect];
    _generalGroupView.backgroundColor = [UIColor whiteColor];
    _generalGroupView.layer.borderWidth = 0.5f;
    _generalGroupView.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
    [self.view addSubview:_generalGroupView];
    
    // General Group Label
    _generalGroupLabel = [[UILabel alloc] initWithFrame:_generalGroupLabelRect];
    _generalGroupLabel.font = [UIFont systemFontOfSize:12];
    _generalGroupLabel.textColor = UIColorFromRGB(0x6d6d72);
    _generalGroupLabel.text = [NSLocalizedString(@"generalGroupLabel", nil) uppercaseString];
    [self.view addSubview:_generalGroupLabel];
    
    // Notifications label
    _notificationsSwitcherLabel = [[UILabel alloc] initWithFrame:_notificationsLabelRect];
    _notificationsSwitcherLabel.text = NSLocalizedString(@"notificationsSettings", nil);
    [self.view addSubview:_notificationsSwitcherLabel];
    
    // Notifications Switcher
    _notificationsSwitcher = [[UISwitch alloc] initWithFrame:_notificationsSwitcherRect];
    [_notificationsSwitcher addTarget:self action:@selector(switchedNotifications:) forControlEvents:UIControlEventValueChanged];
    if ([_appDelegate checkIfNotificationsAreEnabled] == YES)
        [_notificationsSwitcher setOn:YES animated:NO];
    else [_notificationsSwitcher setOn:NO animated:NO];
    [self.view addSubview:_notificationsSwitcher];
    
    // Horizontal line
    _horizontalLine = [[UILabel alloc] initWithFrame:_horizontalLineRect];
    _horizontalLine.backgroundColor = UIColorFromRGB(0xc8c7cc);
    [self.view addSubview:_horizontalLine];
    
    // Languages label
    _languagesSwitcherLabel = [[UILabel alloc] initWithFrame:_languagesLabelRect];
    _languagesSwitcherLabel.text = NSLocalizedString(@"languagesSettings", nil);
    [self.view addSubview:_languagesSwitcherLabel];
    
    // Languages switch
    _languageSwitcher = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Eng", @"Рус", @"Укр", nil]];
    _languageSwitcher.frame = _languagesSwitcherRect;
    _languageSwitcher.selectedSegmentIndex = _lang;
    _languageSwitcher.tintColor = UIColorFromRGB(0x007aff);
    [_languageSwitcher addTarget:self action:@selector(languageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_languageSwitcher];
    
    // Database Group View
    _databaseGroupView = [[UIView alloc] initWithFrame:_databaseGroupViewRect];
    _databaseGroupView.backgroundColor = [UIColor whiteColor];
    _databaseGroupView.layer.borderWidth = 0.5f;
    _databaseGroupView.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
    [self.view addSubview:_databaseGroupView];
    
    // Database Group Label
    _databaseGroupLabel = [[UILabel alloc] initWithFrame:_databaseGroupLabelRect];
    _databaseGroupLabel.font = [UIFont systemFontOfSize:12];
    _databaseGroupLabel.textColor = UIColorFromRGB(0x6d6d72);
    _databaseGroupLabel.text = [NSLocalizedString(@"databaseGroupLabel", nil) uppercaseString];
    [self.view addSubview:_databaseGroupLabel];
    
    // Database Status Label
    _databaseStatusLabel = [[UILabel alloc] initWithFrame:_databaseStatusLabelRect];
    NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
    [_dateFormat setDateFormat:@"dd MMM YYYY"];
    [_dateFormat setLocale:[NSLocale currentLocale]];
    [_dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSMutableString *_addString = [[NSMutableString alloc] initWithFormat:@" (%ld ", (long)[_newOrganizations[_lang] integerValue]];
    [_addString appendString:NSLocalizedString(@"organizations", nil)];
    [_addString appendString:@")"];
    _databaseStatusLabel.text = [[_dateFormat stringFromDate:_currentPlistDate] stringByAppendingString:_addString];
    [self.view addSubview:_databaseStatusLabel];
    
    // Reload DB button
    _reloadDatabaseButton = [[UIButton alloc] initWithFrame:_reloadDatabaseButtonRect];
    [_reloadDatabaseButton setImage:[UIImage imageNamed:@"webViewRefreshButtonEnabled@2x"] forState:UIControlStateNormal];
    [_reloadDatabaseButton setImage:[UIImage imageNamed:@"webViewRefreshButtonEnabled@2x"] forState:UIControlStateHighlighted];
    _reloadDatabaseButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [_reloadDatabaseButton addTarget:self action:@selector(reloadDatabaseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reloadDatabaseButton];
    
    // Init rows for the small TableView in the end
    _infoGroupTableRows = [[NSArray alloc] initWithObjects:@"feedbackRow", @"aboutUsRow", nil];
    
    // Small TableView in the end
    _infoGroupTable = [[UITableView alloc] initWithFrame:_infoGroupTableViewRect];
    _infoGroupTable.scrollEnabled = NO;
    [_infoGroupTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _infoGroupTable.backgroundColor = [UIColor whiteColor];
    _infoGroupTable.layer.borderWidth = 0.5f;
    _infoGroupTable.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
    _infoGroupTable.delegate = self;
    _infoGroupTable.dataSource = self;
    [self.view addSubview:_infoGroupTable];
    
    // Horizontal line 2
    _horizontalLine2 = [[UILabel alloc] initWithFrame:_horizontalLine2Rect];
    _horizontalLine2.backgroundColor = UIColorFromRGB(0xc8c7cc);
    [self.view addSubview:_horizontalLine2];
    
    // Info Group Label
    _infoGroupLabel = [[UILabel alloc] initWithFrame:_infoGroupLabelRect];
    _infoGroupLabel.font = [UIFont systemFontOfSize:12];
    _infoGroupLabel.textColor = UIColorFromRGB(0x6d6d72);
    _infoGroupLabel.text = [NSLocalizedString(@"infoGroupLabel", nil) uppercaseString];
    [self.view addSubview:_infoGroupLabel];
}

// Return one section in TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return two rows in TableView
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return 2;
}

// Initialize cell content
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *_cellindentifier = @"SettingsCellIdentifier";
    UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellindentifier];
    if (_cell == nil)
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellindentifier];
    }
    
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _cell.textLabel.text = NSLocalizedString(_infoGroupTableRows[indexPath.row], nil);
    
    return _cell;
}

// Move to other Views after choosing one row
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // If feedback
    if (indexPath.row == 0)
    [self.navigationController pushViewController:_feedbackViewController animated:YES];
    
    // else about us
    else 
    {
        _previousViewControllerName = @"SettingsViewController";
        [self.navigationController pushViewController:_webViewController animated:YES];
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        
        // If there's no connection - load local html. If there is - load from the web
        if (networkStatus != NotReachable)
        {
            
            NSURL *_aboutusWebAddress = [NSURL URLWithString:_webFileAboutus];
            NSURLRequest *_request = [NSURLRequest requestWithURL:_aboutusWebAddress cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0];
            NSURLResponse *_response;
            NSError *_error;
            NSData *_urlData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&_response error:&_error];
            if (_urlData)
                [_urlData writeToFile:_aboutusFilePath atomically:YES];
        }
        NSURL *_aboutusLocalAddress = [NSURL fileURLWithPath:_aboutusFilePath];
        NSDictionary *_webLink = [NSDictionary dictionaryWithObject:_aboutusLocalAddress forKey:@"_webLink"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"_webLink" object:nil userInfo:_webLink];
        
    }
}

// Animations while updating the database
- (void)databaseUpdating: (UIViewAnimationOptions) options {
    // If it's in the proccess - just blink the 'updating...' label.
    if (_databaseIsUpdating)
        {
            [UIView animateWithDuration:0.5 animations:^{
            _databaseStatusLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                _databaseStatusLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    [self databaseUpdating: UIViewAnimationOptionCurveLinear];
                }];
            }];
        }
    // But when it finished updating update the label to contain if there were updates, how many and the new status
    else
    {
        NSInteger _newOrganizationsAmount = [_newOrganizations[_lang] integerValue] - [_totalOrganizations[_lang] integerValue];
        if (_newOrganizationsAmount == 0)
        {
            _databaseStatusLabel.textColor = UIColorFromRGB(0x007aff);
            _databaseStatusLabel.text = NSLocalizedString(@"noNewUpdates", nil);
        }
        else
        {
            NSMutableString *_updateString = [[NSMutableString alloc] initWithFormat:@"%@ %ld %@", NSLocalizedString(@"addedOrganizations", nil), (long)_newOrganizationsAmount, NSLocalizedString(@"organizations", nil)];
            _databaseStatusLabel.textColor = UIColorFromRGB(0x007aff);
            _databaseStatusLabel.text = _updateString;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            _databaseStatusLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _databaseStatusLabel.alpha = 0;
            } completion:^(BOOL finished) {
                _databaseStatusLabel.textColor = [UIColor blackColor];
        
                NSDateFormatter *_dateFormat = [[NSDateFormatter alloc] init];
                [_dateFormat setDateFormat:@"dd MMM YYYY"];
                [_dateFormat setLocale:[NSLocale currentLocale]];
                [_dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                NSMutableString *_addString = [[NSMutableString alloc] initWithFormat:@" (%ld ", (long)[_newOrganizations[_lang] integerValue]];
                [_addString appendString:NSLocalizedString(@"organizations", nil)];
                [_addString appendString:@")"];
                _databaseStatusLabel.text = [[_dateFormat stringFromDate:_currentPlistDate] stringByAppendingString:_addString];
                [UIView animateWithDuration:0.5 animations:^{
                    _databaseStatusLabel.alpha = 1;
                } completion:^(BOOL finished) {
                _reloadDatabaseButton.enabled = YES;
                    }];
            }];
        }];
    }
}

// Start updating the database
- (void)databaseStartUpdating {
    if (!_databaseIsUpdating) {
        _databaseIsUpdating = YES;
        [self databaseUpdating: UIViewAnimationOptionCurveLinear];
    }
}

// Stop database updating
- (void)databaseStopUpdating {
    _databaseIsUpdating = NO;
}

// Reload DB button action
- (void)reloadDatabaseButtonAction
{
    _reloadDatabaseButton.enabled = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if (networkStatus != NotReachable)
        [UIView animateWithDuration:0.5 animations:^{
            _databaseStatusLabel.alpha = 0;
        } completion:^(BOOL finished) {
                [_databaseStatusLabel setText:NSLocalizedString(@"reloadDatabaseLabel", nil)];
                [[NSNotificationCenter defaultCenter] postNotificationName: @"downloadDict" object: nil];
                [self databaseStartUpdating];
            
        }];
    else
            [self noInternetMessage];
    
}

// Update the database label with a 'No Internet' message if there isn't one.
- (void)noInternetMessage
{
    [UIView animateWithDuration:0.5 animations:^{
        _databaseStatusLabel.alpha = 0;
    } completion:^(BOOL finished) {
        _databaseStatusLabel.textColor = UIColorFromRGB(0x007aff);
        NSString *_temporaryString = _databaseStatusLabel.text;
        _databaseStatusLabel.text = NSLocalizedString(@"noInternet", nil);
        [UIView animateWithDuration:0.5 animations:^{
            _databaseStatusLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _databaseStatusLabel.alpha = 0;
            } completion:^(BOOL finished) {
                _databaseStatusLabel.textColor = [UIColor blackColor];
                _databaseStatusLabel.text = _temporaryString;
                [UIView animateWithDuration:0.5 animations:^{
                    _databaseStatusLabel.alpha = 1;
                } completion:^(BOOL finished) {
                    _reloadDatabaseButton.enabled = YES;
                }];
            }];
        }];
    }];
}

// Switch on and off push notifications
- (void)switchedNotifications:(id)sender
{
    if([sender isOn]){
        
        // Execute any code when the switch is ON
        #ifdef DEBUG
        NSLog(@"Switch is ON");
        #endif
        
        #if TARGET_IPHONE_SIMULATOR
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Pushes"
                                                            message:@"are on ios8."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [_alert show];
        } else {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Pushes"
                                                            message:@"are on ios7."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [_alert show];
        }
        #elif TARGET_OS_IPHONE
        if ([_userDefaults integerForKey:@"_wasPromptedForPushNotifications"] == 0)
        {
            [_appDelegate registerForPushNotifications];
            [_userDefaults setInteger:1 forKey:@"_wasPromptedForPushNotifications"];
            [_userDefaults synchronize];
            [_notificationsSwitcher setOn:YES animated:NO];
        }
        else
        {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"enableNotificationsAlarmTitle", nil)
                                                            message:NSLocalizedString(@"enableNotificationsSwitcherAlarmMessage", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"enableNotificationsAlarmCancelButton", nil)
                                                  otherButtonTitles:nil];
            [_alert show];
            [_notificationsSwitcher setOn:NO animated:NO];
        }
        #endif
        
    } else{
        #ifdef DEBUG
        NSLog(@"Switch is OFF");
        #endif
        #if TARGET_IPHONE_SIMULATOR
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Pushes"
                                                            message:@"are off ios8."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [_alert show];
        } else {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Pushes"
                                                            message:@"are off ios7."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [_alert show];
        }
        #elif TARGET_OS_IPHONE
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"disableNotificationsAlarmTitle", nil)
                                                        message:NSLocalizedString(@"disableNotificationsSwitcherAlarmMessage", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"disableNotificationsAlarmCancelButton", nil)
                                              otherButtonTitles:nil];
        [_alert show];
        [_notificationsSwitcher setOn:YES animated:NO];
        #endif
    }
}

// Change app language
- (void)languageChanged:(UISegmentedControl *)segment {
    NSString *_sysLang;
    if(segment.selectedSegmentIndex == 0) {
        _lang = 0;
        _sysLang = @"en";
    }else if(segment.selectedSegmentIndex == 1){
        _lang = 1;
        _sysLang = @"ru";
    }else if(segment.selectedSegmentIndex == 2){
        _lang = 2;
        _sysLang = @"uk";
    }
    [_userDefaults setObject:[NSArray arrayWithObject:_sysLang] forKey:@"AppleLanguages"]; //
    [_userDefaults setInteger:_lang forKey:@"_lang"];
    [_userDefaults synchronize];
    
    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"languageChanged", nil)
                                                    message:NSLocalizedString(@"pleaseRestart", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"languageChangedCancelButton", nil)
                                          otherButtonTitles:nil];
    [_alert show];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register for incoming notifications
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(databaseStopUpdating) name: @"databaseStopUpdating" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

// Stop the animation when the user leaves the view
- (void)viewWillDisappear:(BOOL)animated
{
    [self databaseStopUpdating];
}

// Update notification switch when you get back to the app
- (void)didEnterForeground
{
    if ([_appDelegate checkIfNotificationsAreEnabled] == YES)
        [_notificationsSwitcher setOn:YES animated:NO];
    else [_notificationsSwitcher setOn:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
