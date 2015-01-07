//
//  FeedbackViewController.m
//  HelpUkraine
//
//  Created by Admin on 12/21/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Constants.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Set View's background and title
        self.view.backgroundColor = UIColorFromRGB(0xefeff4);
        self.title = NSLocalizedString(@"feedbackViewNavigationTitle", nil);
        
        [self initView];
    }
    return self;
}

// Init the view
- (void)initView {
    
    // Some constants
    float _lineHeight = 44;
    float _navBar = 64;
    
    // Rectangles for the UI elements
    CGRect _emailAddressTextFieldRect = CGRectMake(0, _navBar + 5, _bounds.size.width, _lineHeight);
    CGRect _messageTextViewRect = CGRectMake(0, _navBar + _lineHeight + 10, _bounds.size.width, 4 * _lineHeight);
    CGRect _messagePlaceholderLabelRect = CGRectMake(15, 0, _bounds.size.width - 15, _lineHeight);
    
    // Email address Text Field
    _emailAddressTextField = [[UITextField alloc] initWithFrame:_emailAddressTextFieldRect];
    _emailAddressTextField.backgroundColor = [UIColor whiteColor];
    _emailAddressTextField.layer.borderWidth = 0.5f;
    _emailAddressTextField.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
    _emailAddressTextField.placeholder = NSLocalizedString(@"emailPlaceholder", nil);
    UIView *_leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, _lineHeight)];
    _emailAddressTextField.leftView = _leftPaddingView;
    _emailAddressTextField.leftViewMode = UITextFieldViewModeAlways;
    _emailAddressTextField.delegate = self;
    _emailAddressTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:_emailAddressTextField];
    
    // Message Text View
    _messageTextView = [[UITextView alloc] initWithFrame:_messageTextViewRect];
    _messageTextView.delegate = self;
    _messageTextView.backgroundColor = [UIColor whiteColor];
    _messageTextView.layer.borderWidth = 0.5f;
    _messageTextView.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
    _messageTextView.font = [UIFont systemFontOfSize:16];
    _messageTextView.textContainerInset = UIEdgeInsetsMake(12, 10, 0, 0);
    [self.view addSubview:_messageTextView];
    
    // The message placeholder label
    _messagePlaceholder = [[UILabel alloc] initWithFrame:_messagePlaceholderLabelRect];
    _messagePlaceholder.text = NSLocalizedString(@"messagePlaceholder", nil);
    _messagePlaceholder.textColor = UIColorFromRGB(0xc7c7cd);
    _messagePlaceholder.backgroundColor = [UIColor clearColor];
    [_messageTextView addSubview:_messagePlaceholder];
    
    // Add the 'send' button on the top-right
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sendFeedback", nil) style:UIBarButtonItemStyleDone target:self action:@selector(sendFeedback)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

// Changes the 'send' button to 'done' which dismisses keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
}

// If you tap the 'next' button you'll be brought from the email to the message field
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [_messageTextView becomeFirstResponder];
    return NO;
}

// Changes the 'send' button to 'done' which dismisses keyboard and hides the message placeholder label
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    if (![textView hasText]) {
        _messagePlaceholder.hidden = NO;
    }
    return YES;
}

// Dismiss the keyboard after done editing and change back the 'done' to 'send' button. Also check if two text fields are entered and enable the 'send' button which is disabled by default
- (void)doneEditing
{
    self.navigationItem.rightBarButtonItem = nil;
    [_messageTextView resignFirstResponder];
    [_emailAddressTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sendFeedback", nil) style:UIBarButtonItemStyleDone target:self action:@selector(sendFeedback)];
    if ([_messageTextView hasText] && [_emailAddressTextField hasText])
        self.navigationItem.rightBarButtonItem.enabled = YES;
    else self.navigationItem.rightBarButtonItem.enabled = NO;
        
}

// Send the feedback email
- (void)sendFeedback
{
    NSString *_email = _emailAddressTextField.text;
    NSString *_message = _messageTextView.text;
    NSString *_requestString = [NSString stringWithFormat:@"email=%@&message=%@", _email, _message];
    NSData *_requestData = [_requestString dataUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *_request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: _webFileFeedback ] ];
    [_request setHTTPMethod: @"POST"];
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [_request setHTTPBody: _requestData];
    [_request setTimeoutInterval:5.0];
    NSURLResponse *_response;
    NSError *_err;
    NSData *_returnData = [ NSURLConnection sendSynchronousRequest: _request returningResponse:&_response error:&_err];
    NSString *_responseBody = [[NSString alloc] initWithData:_returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Feedback sent. PHP Answer: %@", _responseBody);
    
    // 'Everything went great' alert
    if ([_responseBody isEqualToString:@"SEND"])
    {
        _feedbackResultGood = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feedbackMessageThankYou", nil) message:NSLocalizedString(@"feedbackMessageGood", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"feedbackButtonOkay", nil) otherButtonTitles:nil, nil];
        _feedbackResultGood.tag = 1;
        [_feedbackResultGood show];
    }
    // 'Everything went bad' alert
    else
    {
        _feedbackResultBad = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"feedbackMessageError", nil) message:NSLocalizedString(@"feedbackMessageBad", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"feedbackButtonOkay", nil) otherButtonTitles:nil, nil];
        _feedbackResultBad.tag = 2;
        [_feedbackResultBad show];
    }
}

// If everything went well clear all the text fields
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        _messageTextView.text = @"";
        _emailAddressTextField.text = @"";
        self.navigationItem.rightBarButtonItem.enabled = NO;
        _messagePlaceholder.hidden = NO;

    }
}

// Hide message placeholder if there is text in the message TextView
- (void)textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        _messagePlaceholder.hidden = NO;
    }
    else{
        _messagePlaceholder.hidden = YES;
    }
}

- (void)viewDidLoad {
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
