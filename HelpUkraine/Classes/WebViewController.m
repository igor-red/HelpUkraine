//
//  WebViewController.m
//  HelpUkraine
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"
#import "SettingsViewController.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Setting initial number of loaded pages in web view's back/forward pool
        _webViewPoolPageOrder = 0;
        _openedFirstLink = NO;
        _didStop = NO;
        _webViewLoads = 0;
        
        // Initialize background color and navigation title
        self.view.backgroundColor = [UIColor whiteColor];
        
        // Create webview
        _webView = [[UIWebView alloc] initWithFrame:_bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
        
        // If you came from the Details View then initialize the toolbar
        if ([_previousViewControllerName isEqualToString:@"DetailsViewController"])
        {
            // And change the title
            self.title = NSLocalizedString(@"WebViewNavigationTitle", nil);
                
            // Toolbar buttons size
            CGFloat _buttonSize = 30;
            
            // Back button
            UIButton *_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *_backButtonEnabledImage = [UIImage imageNamed:@"webViewBackButtonEnabled.png"];
            UIImage *_backButtonDisabledImage = [UIImage imageNamed:@"webViewBackButtonDisabled.png"];
            _backButton.bounds = CGRectMake( 0, 0, _buttonSize, _buttonSize );
            [_backButton setImage:_backButtonEnabledImage forState:UIControlStateNormal];
            [_backButton setImage:_backButtonDisabledImage forState:UIControlStateDisabled];
            [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _backButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
            _backButtonBarItem.enabled = NO;
            
            // Forward button
            UIButton *_forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *_forwardButtonEnabledImage = [UIImage imageNamed:@"webViewForwardButtonEnabled.png"];
            UIImage *_forwardButtonDisabledImage = [UIImage imageNamed:@"webViewForwardButtonDisabled.png"];
            _forwardButton.bounds = CGRectMake( 0, 0, _buttonSize, _buttonSize );
            [_forwardButton setImage:_forwardButtonEnabledImage forState:UIControlStateNormal];
            [_forwardButton setImage:_forwardButtonDisabledImage forState:UIControlStateDisabled];
            [_forwardButton addTarget:self action:@selector(forwardButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _forwardButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:_forwardButton];
            _forwardButtonBarItem.enabled = NO;
            
            // Stop button
            UIButton *_stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *_stopButtonEnabledImage = [UIImage imageNamed:@"webViewStopButtonEnabled.png"];
            UIImage *_stopButtonDisabledImage = [UIImage imageNamed:@"webViewStopButtonDisabled.png"];
            _stopButton.bounds = CGRectMake( 0, 0, _buttonSize, _buttonSize );
            [_stopButton setImage:_stopButtonEnabledImage forState:UIControlStateNormal];
            [_stopButton setImage:_stopButtonDisabledImage forState:UIControlStateDisabled];
            [_stopButton addTarget:self action:@selector(stopButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _stopButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:_stopButton];
            
            // Refresh button
            UIButton *_refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *_refreshButtonEnabledImage = [UIImage imageNamed:@"webViewRefreshButtonEnabled.png"];
            UIImage *_refreshButtonDisabledImage = [UIImage imageNamed:@"webViewRefreshButtonDisabled.png"];
            _refreshButton.bounds = CGRectMake( 0, 0, _buttonSize, _buttonSize );
            [_refreshButton setImage:_refreshButtonEnabledImage forState:UIControlStateNormal];
            [_refreshButton setImage:_refreshButtonDisabledImage forState:UIControlStateDisabled];
            [_refreshButton addTarget:self action:@selector(refreshButtonAction) forControlEvents:UIControlEventTouchUpInside];
            _refreshButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:_refreshButton];
            _refreshButtonBarItem.enabled = NO;
            
            // Add all items together
            NSMutableArray *_toolBarItems =[NSMutableArray array];
            [_toolBarItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
            [_toolBarItems addObject:_backButtonBarItem];
            [_toolBarItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
            [_toolBarItems addObject:_forwardButtonBarItem];
            [_toolBarItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
            [_toolBarItems addObject:_stopButtonBarItem];
            [_toolBarItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
            [_toolBarItems addObject:_refreshButtonBarItem];
            [_toolBarItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
            
            // Initialize the toolbar
            _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _bounds.size.height - 44, _bounds.size.width, 44)];
            _toolBar.items = _toolBarItems;
            [_toolBar setBarStyle:UIBarStyleDefault];
            [_toolBar setTranslucent:YES];
            [self.view addSubview:_toolBar];

            // Loading activity
            UIView *view = (UIView *)[_refreshButtonBarItem performSelector:@selector(view)];
            _loadingBarItem=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _loadingBarItem.center = CGPointMake(view.frame.origin.x + 7, _bounds.size.height - 44 + 7 + view.frame.size.height / 2);
            [_loadingBarItem startAnimating];
            _loadingBarItem.tag = 100;
            [self.view addSubview:_loadingBarItem];
        }
        // If you came from other places - no toolbar for you
        else
        {
            self.title = NSLocalizedString(@"aboutUsRow", nil);
            
            // Loading activity
            _loadingBarItem=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _loadingBarItem.center = CGPointMake(_bounds.size.width / 2, _bounds.size.height / 2);
            [_loadingBarItem startAnimating];
            _loadingBarItem.tag = 100;
            [self.view addSubview:_loadingBarItem];
        }
        
    }
    return self;
}

// Update the state of toolbar buttons in any situations
- (void)updateButtons
{
    if (_webViewPoolPageOrder == 0 & _openedFirstLink == YES)
    {
        _forwardButtonBarItem.enabled = YES;
        _backButtonBarItem.enabled = NO;
    }
    else if (_webViewPoolPageOrder != 0 & _openedFirstLink == YES)
    {
        _backButtonBarItem.enabled = YES;
        _forwardButtonBarItem.enabled = NO;
    }
    _stopButtonBarItem.enabled = !_didStop;
    if (_didStop == NO)
    {
        [_refreshButtonBarItem setEnabled:NO];
        [_loadingBarItem startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    else
    {
        [_refreshButtonBarItem setEnabled:YES];
        [_loadingBarItem stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

// The back button action
- (void)backButtonAction
{
    _webViewPoolPageOrder--;
    [self updateButtons];
    [_webView goBack];
}

// The forward button action
- (void)forwardButtonAction
{
    _webViewPoolPageOrder++;
    [self updateButtons];
    [_webView goForward];
}

// The stop button action
- (void)stopButtonAction
{
    _didStop = YES;
    [self updateButtons];
    [_webView stopLoading];
}

// The refresh button action
- (void)refreshButtonAction
{
    if ([self isThereInternet] == YES)
    {
        _didStop = NO;
        [self updateButtons];
        if (_wasOffline == YES)
        {
            _wasOffline = NO;
            [_webView loadRequest:_urlRequest];
        }
            else [_webView reload];
    }
    else
    {
        _didStop = YES;
        [self updateButtons];
        [self noInternetMessage];
    }
}

// Override the 'open page via click on a link' method
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        if ([self isThereInternet] == YES)
        {
            _didStop = NO;
            _webViewLoads = 0;
            _openedFirstLink = YES;
            _webViewPoolPageOrder++;
            [self updateButtons];
            NSLog(@"%ld", (long)_webViewPoolPageOrder);
            [webView loadRequest:request];
        }
        else [self noInternetMessage];
    }
    return YES;
}

// Let's you count loaded frames
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webViewLoads++;
}

// Counts finished frames, moves the scroll view and lets you pinch it
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([_previousViewControllerName isEqualToString:@"DetailsViewController"])
    {
    _webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    }
    _webViewLoads--;
    
    if (_webViewLoads != 0)
        return;
    _didStop = YES;
    [self updateButtons];
    webView.scrollView.delegate = self;
    webView.scrollView.maximumZoomScale = 20;
    webView.scrollView.minimumZoomScale = 1;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    _webView.scrollView.maximumZoomScale = 20;
}

// Continue counting loaded frames
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _webViewLoads--;
}

// Check for Internet
- (BOOL)isThereInternet
{
    Reachability *_reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus _networkStatus = [_reachability currentReachabilityStatus];
    return _networkStatus != NotReachable;
}

- (void)openWebLink:(NSNotification *) notif
{
    NSDictionary *_webLink = [notif.userInfo mutableCopy];
    _urlRequest = [NSURLRequest requestWithURL:[_webLink objectForKey:@"_webLink"]];
    if ([_previousViewControllerName isEqualToString:@"DetailsViewController"])
    {
        _wasOffline = NO;
        if ([self isThereInternet] == NO)
        {
            _wasOffline = YES;
            [self stopButtonAction];
            [self noInternetMessage];
        }
        else
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [_webView loadRequest:_urlRequest];
        }
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [_webView loadRequest:_urlRequest];
    }
    
    
    //if ([_previousViewControllerName isEqualToString:@"SettingsViewController"])
      //  _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(loadLocal) userInfo:nil repeats:NO];
}

- (void)noInternetMessage
{
    UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noInternet", nil)
                                                     message:NSLocalizedString(@"connectToInternet", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
    [_alert show];
}

- (void)loadLocal
{
    
}

- (void)viewWillDisappear
{
    if ([_webView isLoading])
        [_webView stopLoading];
        //[self destroyWebView];
}

- (void)destroyWebView
{
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView setDelegate:nil];
    [_webView removeFromSuperview];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWebLink:) name:@"_webLink" object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
