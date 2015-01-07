//
//  PushViewController.m
//  HelpUkraine
//
//  Created by Admin on 9/7/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "PushViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "Constants.h"


@implementation PushViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        [self initView];
        
    }
    return self;
}


// Init views
- (void)initView
{
    // View's white background
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Initializing Frames for elements
    CGFloat _offset = (_bounds.size.width - 270) / 2;
    CGRect outerLine = CGRectMake(_offset, (_bounds.size.height - 150) / 2, 270.0, 150.0);
    CGRect horizontalLine = CGRectMake(_offset, (_bounds.size.height - 150) / 2 + 104, 270, 1);
    CGRect verticalLine = CGRectMake(_bounds.size.width / 2, (_bounds.size.height - 150) / 2 + 104, 1, 46);
    CGRect enablePushTitle = CGRectMake(_offset, (_bounds.size.height - 150) / 2 + 5, 270, 50);
    CGRect enablePushText = CGRectMake(_offset, (_bounds.size.height - 150) / 2 + 20, 270, 100);
    CGRect enablePushButton = CGRectMake(_bounds.size.width / 2, (_bounds.size.height - 150) / 2 + 104, 135, 46);
    CGRect cancelPushButton = CGRectMake(_offset, (_bounds.size.height - 150) / 2 + 104, 135, 46);
    CGRect startButton = CGRectMake(_offset, _bounds.size.height / 2 - 25, 270, 50);
    
    
    // Outer line
    _outerLine = [[UILabel alloc] initWithFrame:outerLine];
    _outerLine.layer.borderWidth = 1.0f;
    _outerLine.layer.cornerRadius = 10;
    _outerLine.layer.borderColor = UIColorFromRGB(0xD6D6D6).CGColor;
    [self.view addSubview:_outerLine];
    
    // Horizontal line
    _horizontalLine = [[UILabel alloc] initWithFrame:horizontalLine];
    _horizontalLine.backgroundColor = UIColorFromRGB(0xD6D6D6);
    [self.view addSubview:_horizontalLine];
    
    // Vertical inner line
    _verticalLine = [[UILabel alloc] initWithFrame:verticalLine];
    _verticalLine.backgroundColor = UIColorFromRGB(0xD6D6D6);
    [self.view addSubview:_verticalLine];
    
    // Title
    _enablePushTitle = [[UILabel alloc] initWithFrame:enablePushTitle];
    [_enablePushTitle setText:NSLocalizedString(@"enablePushTitle", nil)];
    _enablePushTitle.font = [UIFont boldSystemFontOfSize:16];
    _enablePushTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_enablePushTitle];
    
    // Text
    _enablePushText = [[UILabel alloc] initWithFrame:enablePushText];
    [_enablePushText setText:NSLocalizedString(@"enablePushText", nil)];
    _enablePushText.numberOfLines = 0;
    _enablePushText.font = [UIFont systemFontOfSize:14];
    _enablePushText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_enablePushText];
    
    // OK button
    _enablePushButton = [[UIButton alloc] initWithFrame:enablePushButton];
    [_enablePushButton setTitleColor:UIColorFromRGB(0x0084FF) forState:UIControlStateNormal];
    [_enablePushButton setTitle:NSLocalizedString(@"enablePushButton", nil) forState:UIControlStateNormal];
    [_enablePushButton addTarget:self action:@selector(enablePushButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enablePushButton];
    
    // Not Now button
    _cancelPushButton = [[UIButton alloc] initWithFrame:cancelPushButton];
    [_cancelPushButton setTitleColor:UIColorFromRGB(0x0084FF) forState:UIControlStateNormal];
    [_cancelPushButton setTitle:NSLocalizedString(@"cancelPushButton", nil) forState:UIControlStateNormal];
    [_cancelPushButton addTarget:self action:@selector(startButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelPushButton];
    
    // Start button
    _startButton = [[UIButton alloc] initWithFrame:startButton];
    [_startButton setTitleColor:UIColorFromRGB(0x0084FF) forState:UIControlStateNormal];
    [_startButton setTitle:NSLocalizedString(@"startButton", nil) forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startButton) forControlEvents:UIControlEventTouchUpInside];
    _startButton.hidden = YES;
    [self.view addSubview:_startButton];
}

// Enable Push notifications button
- (void)enablePushButton
{
    // Register for push notifications
    [_appDelegate registerForPushNotifications];
    [_userDefaults setInteger:1 forKey:@"_wasPromptedForPushNotifications"];
    [_userDefaults synchronize];
    
    // Hiding the notification and showing the startBtn
    _outerLine.hidden = YES;
    _horizontalLine.hidden = YES;
    _verticalLine.hidden = YES;
    _enablePushTitle.hidden = YES;
    _enablePushText.hidden = YES;
    _enablePushButton.hidden = YES;
    _cancelPushButton.hidden = YES;
    _startButton.hidden = NO;
}

// Start the app for the first time
- (void)startButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"collectAPNSandSendData" object: nil];
    UINavigationController *_navController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
    [_navController.navigationBar setBackgroundImage:[UIImage new]
                                       forBarMetrics:UIBarMetricsDefault];
    _navController.navigationBar.shadowImage = [UIImage new];
    _navController.navigationBar.translucent = YES;
    [_navController setNavigationBarHidden:YES];
    [self presentViewController:_navController animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
