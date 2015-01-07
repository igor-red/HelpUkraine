//
//  FeedbackViewController.h
//  HelpUkraine
//
//  Created by Admin on 12/21/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    // Email and message text fields
    UITextField *_emailAddressTextField;
    UITextView *_messageTextView;
    UILabel *_messagePlaceholder;
    
    // Result AlertViews
    UIAlertView *_feedbackResultGood;
    UIAlertView *_feedbackResultBad;
}

@end
