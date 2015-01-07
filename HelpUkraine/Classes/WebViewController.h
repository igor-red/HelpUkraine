//
//  WebViewController.h
//  HelpUkraine
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>
{
    // WebView
    UIWebView *_webView;
    
    // Toolbar and its items
    UIToolbar *_toolBar;
    UIBarButtonItem *_backButtonBarItem;
    UIBarButtonItem *_forwardButtonBarItem;
    UIBarButtonItem *_refreshButtonBarItem;
    UIBarButtonItem *_stopButtonBarItem;
    
    // Activity Indicator
    UIActivityIndicatorView *_loadingBarItem;
    
    // Many workarounds to make the WebView to look like it's working like it should
    BOOL _didStop;
    NSInteger _webViewLoads;
    NSInteger _webViewPoolPageOrder;
    BOOL _openedFirstLink;
    NSURLRequest *_urlRequest;
    BOOL _wasOffline;
}

@end
