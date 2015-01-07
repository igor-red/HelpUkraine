//
//  FirstViewController.m
//  HelpUkraine
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "MainViewController.h"
#import "ListViewController.h"
#import "AppDelegate.h"
#import "SendHelpViewController.h"
#import "PushViewController.h"
#import "SettingsViewController.h"

@implementation MainViewController

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
    
    // Initializing Rectangles for the big buttons buttons
    float _margin = 8;
    float _buttonWidth = _bounds.size.width / 2 - _margin * 1.5;
    float _buttonHeight = (_bounds.size.height - _statusBarHeight ) / 2 - _margin * 1.5;
    
    // News button frames
    CGRect _newsButtonRect = CGRectMake(0 + _margin, 0 + _statusBarHeight + _margin, _buttonWidth, _buttonHeight);
    CGRect _newsButtonLabelRect = CGRectMake(0 + _margin, 0 + _statusBarHeight + _margin, _buttonWidth, _buttonHeight / 3);
    CGRect _comingSoonLabel1Rect = CGRectMake(0 + _margin, (_bounds.size.height - _statusBarHeight ) / 2 - _margin * 3.1, _buttonWidth, 20);
    
    // Get help button frames
    CGRect _getHelpButtonRect = CGRectMake(_bounds.size.width / 2 + _margin * 0.5, 0 + _statusBarHeight + _margin, _buttonWidth, _buttonHeight);
    CGRect _getHelpButtonLabelRect = CGRectMake(_bounds.size.width / 2 + _margin * 0.5, 0 + _statusBarHeight + _margin, _buttonWidth, _buttonHeight / 3);
    CGRect _comingSoonLabel2Rect = CGRectMake(_bounds.size.width / 2 + _margin * 0.5, (_bounds.size.height - _statusBarHeight ) / 2 - _margin * 3.1, _buttonWidth, 20);
    
    // Send help button frames
    CGRect _sendHelpButtonRect = CGRectMake(0 + _margin, (_bounds.size.height - _statusBarHeight) / 2 + _statusBarHeight + _margin * 0.5, _buttonWidth, _buttonHeight);
    CGRect _sendHelpButtonLabelRect = CGRectMake(0 + _margin, (_bounds.size.height - _statusBarHeight) / 2 + _statusBarHeight + _margin * 0.5, _buttonWidth, _buttonHeight / 3);
    
    // Settings button frames
    CGRect _settingsButtonRect = CGRectMake(_bounds.size.width / 2 + _margin * 0.5, (_bounds.size.height - _statusBarHeight) / 2 + _statusBarHeight + _margin * 0.5, _buttonWidth, _buttonHeight);
    CGRect _settingsButtonLabelRect = CGRectMake(_bounds.size.width / 2 + _margin * 0.5, (_bounds.size.height - _statusBarHeight) / 2 + _statusBarHeight + _margin * 0.5, _buttonWidth, _buttonHeight / 3);
    
    
    // Spacing for the 'soon' label depending on screen size
    CGFloat _spacing;
    if (_iPhone4)
        _spacing = 80;
    else if (_iPhone5)
        _spacing = 90;
    else _spacing = 120;
    
    // Setting color and font for titles and the 'soon' labels
    UIColor *_titlesColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIFont *_titlesFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
    UIColor *_comingSoonColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIFont *_comingSoonFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15];
    
    
    // News button
    _newsButton = [[UIButton alloc] initWithFrame:_newsButtonRect];
    [_newsButton setBackgroundColor: UIColorFromRGB(0x6dc763)];
    [_newsButton setImage:[UIImage imageNamed:@"mainViewNews.png"] forState:UIControlStateNormal];
    [_newsButton setImage:[UIImage imageNamed:@"mainViewNews.png"] forState:UIControlStateHighlighted];
    _newsButton.layer.cornerRadius = 10;
    [self.view addSubview:_newsButton];
    
    // News label
    _newsButtonLabel = [[UILabel alloc] initWithFrame:_newsButtonLabelRect];
    _newsButtonLabel.text = NSLocalizedString(@"newsButton", nil);
    _newsButtonLabel.textColor = _titlesColor;
    _newsButtonLabel.font = _titlesFont;
    _newsButtonLabel.textAlignment = NSTextAlignmentCenter;
    _newsButtonLabel.numberOfLines = 0;
    [self.view addSubview:_newsButtonLabel];
    
    // Coming Soon Label 1
    _comingSoonLabel1 = [[UILabel alloc] initWithFrame:_comingSoonLabel1Rect];
    _comingSoonLabel1.text = NSLocalizedString(@"comingSoonLabel1", nil);
    _comingSoonLabel1.font = _comingSoonFont;
    _comingSoonLabel1.textColor = _comingSoonColor;
    _comingSoonLabel1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_comingSoonLabel1];
    
    // Get Help button
    _getHelpButton = [[UIButton alloc] initWithFrame:_getHelpButtonRect];
    [_getHelpButton setBackgroundColor:UIColorFromRGB(0xee5653)];
    [_getHelpButton setImage:[UIImage imageNamed:@"mainViewGetHelp.png"] forState:UIControlStateNormal];
    [_getHelpButton setImage:[UIImage imageNamed:@"mainViewGetHelp.png"] forState:UIControlStateHighlighted];
    _getHelpButton.layer.cornerRadius = 10;
    [self.view addSubview:_getHelpButton];
    
    // Get help label
    _getHelpButtonLabel = [[UILabel alloc] initWithFrame:_getHelpButtonLabelRect];
    _getHelpButtonLabel.text = NSLocalizedString(@"getHelpButton", nil);
    _getHelpButtonLabel.textColor = _titlesColor;
    _getHelpButtonLabel.font = _titlesFont;
    _getHelpButtonLabel.textAlignment = NSTextAlignmentCenter;
    _getHelpButtonLabel.numberOfLines = 0;
    [self.view addSubview:_getHelpButtonLabel];
    
    // Coming Soon Label 2
    _comingSoonLabel2 = [[UILabel alloc] initWithFrame:_comingSoonLabel2Rect];
    _comingSoonLabel2.text = NSLocalizedString(@"comingSoonLabel2", nil);
    _comingSoonLabel2.font = _comingSoonFont;
    _comingSoonLabel2.textColor = _comingSoonColor;
    _comingSoonLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_comingSoonLabel2];
    
    // Send Help button
    _sendHelpButton = [[UIButton alloc] initWithFrame:_sendHelpButtonRect];
    [_sendHelpButton setBackgroundColor:UIColorFromRGB(0xe1d431)];
    [_sendHelpButton addTarget:self action:@selector(sendHelpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendHelpButton setImage:[UIImage imageNamed:@"mainViewSendHelp.png"] forState:UIControlStateNormal];
    [_sendHelpButton setImage:[UIImage imageNamed:@"mainViewSendHelp.png"] forState:UIControlStateHighlighted];
    _sendHelpButton.layer.cornerRadius = 10;
    [self.view addSubview:_sendHelpButton];
    
    // Send help label
    _sendHelpButtonLabel = [[UILabel alloc] initWithFrame:_sendHelpButtonLabelRect];
    _sendHelpButtonLabel.text = NSLocalizedString(@"sendHelpButton", nil);
    _sendHelpButtonLabel.textColor = _titlesColor;
    _sendHelpButtonLabel.font = _titlesFont;
    _sendHelpButtonLabel.textAlignment = NSTextAlignmentCenter;
    _sendHelpButtonLabel.numberOfLines = 0;
    [self.view addSubview:_sendHelpButtonLabel];
    
    // Settings button
    _settingsButton = [[UIButton alloc] initWithFrame:_settingsButtonRect];
    [_settingsButton setBackgroundColor:UIColorFromRGB(0x5590a5)];
    [_settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_settingsButton setImage:[UIImage imageNamed:@"mainViewSettings.png"] forState:UIControlStateNormal];
    [_settingsButton setImage:[UIImage imageNamed:@"mainViewSettings.png"] forState:UIControlStateHighlighted];
    _settingsButton.layer.cornerRadius = 10;
    [self.view addSubview:_settingsButton];
    
    // Settings label
    _settingsButtonLabel = [[UILabel alloc] initWithFrame:_settingsButtonLabelRect];
    _settingsButtonLabel.text = NSLocalizedString(@"settingsButton", nil);
    _settingsButtonLabel.textColor = _titlesColor;
    _settingsButtonLabel.font = _titlesFont;
    _settingsButtonLabel.textAlignment = NSTextAlignmentCenter;
    _settingsButtonLabel.numberOfLines = 0;
    [self.view addSubview:_settingsButtonLabel];
    
}



// Send Help button action
- (void)sendHelpButtonAction
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sendHelpNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:_sendHelpViewController animated:YES];
}

// Settings button action
- (void)settingsButtonAction
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"settingsNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:_settingsViewController animated:YES];
}

// Show navigation bar
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

// Set navigation bar back button
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"backToMainView", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
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
