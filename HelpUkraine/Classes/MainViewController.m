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
    // View's black background
    self.view.backgroundColor = [UIColor blackColor];
    
    // View's background image
    _backgroundImageView = [[UIImageView alloc] initWithFrame:_bounds];
    [_backgroundImageView setImage:[UIImage imageNamed:@"mainBg@3x.jpg"]];
    _backgroundImageView.alpha = 0.5;
    _backgroundImageView.frame = _bounds;
    if (_iPhone4)
        _backgroundImageView.frame = CGRectMake(0, -88, 320, 568);
    [self.view addSubview:_backgroundImageView];

    // Defining image resources
    if (_iPhone6)
    {
        _organizationsImage = [UIImage imageNamed:@"organizations@2x-667.png"];
        _settingsImage = [UIImage imageNamed:@"settings@2x-667.png"];
    }
    else
    {
        _organizationsImage = [UIImage imageNamed:@"organizations.png"];
        _settingsImage = [UIImage imageNamed:@"settings.png"];
    }
    
    // Organizations button
    CGFloat _organizationsImageWidth = _organizationsImage.size.width;
    CGRect _organizationsButtonRect = CGRectMake(_bounds.size.width * 0.25, _bounds.size.height * 0.65, _bounds.size.width * 0.5, _organizationsImageWidth + 40);
    _organizationsButton = [[UIButton alloc] initWithFrame:_organizationsButtonRect];
    [_organizationsButton setImage:_organizationsImage forState:UIControlStateNormal];
    [_organizationsButton setImage:_organizationsImage forState:UIControlStateHighlighted];
    [_organizationsButton setTitle:NSLocalizedString(@"organizationsMain", nil) forState:UIControlStateNormal];
    [_organizationsButton setTitle:NSLocalizedString(@"organizationsMain", nil) forState:UIControlStateHighlighted];
    [_organizationsButton addTarget:self action:@selector(sendHelpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // Center image and label
    CGFloat _spacing = 10;
    _organizationsButton.titleEdgeInsets = UIEdgeInsetsMake( 0.0, - _organizationsImageWidth, - (_organizationsImageWidth + _spacing), 0.0);
    CGSize _organizationsButtonTitleSize = [_organizationsButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _organizationsButton.titleLabel.font}];
    _organizationsButton.imageEdgeInsets = UIEdgeInsetsMake(- (_organizationsButtonTitleSize.height + _spacing), 0.0, 0.0, - _organizationsButtonTitleSize.width);
    [self.view addSubview:_organizationsButton];
    
    // Settings button
    CGFloat _settingsImageSide = _settingsImage.size.width;
    CGRect _settingsButtonRect = CGRectMake(_bounds.size.width - _settingsImageSide * 2, _bounds.size.height - _settingsImageSide * 2, _settingsImageSide * 2, _settingsImageSide * 2);
    _settingsButton = [[UIButton alloc] initWithFrame:_settingsButtonRect];
    [_settingsButton setContentMode:UIViewContentModeScaleAspectFit];
    [_settingsButton setImage:_settingsImage forState:UIControlStateNormal];
    [_settingsButton setImage:_settingsImage forState:UIControlStateHighlighted];
    [_settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingsButton];
    
}

// Send Help button action
- (void)sendHelpButtonAction
{
    if (_iPhone6)
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sendHelpNavBar@2x-667.png"] forBarMetrics:UIBarMetricsDefault];
    else
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"sendHelpNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:_sendHelpViewController animated:YES];
}

// Settings button action
- (void)settingsButtonAction
{
    if (_iPhone6)
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"settingsNavBar@2x-667.png"] forBarMetrics:UIBarMetricsDefault];
    else
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"settingsNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:_settingsViewController animated:YES];
}

// Show navigation bar
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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
