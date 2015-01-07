//
//  PushViewController.h
//  HelpUkraine
//
//  Created by Admin on 9/7/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushViewController : UIViewController <UIAlertViewDelegate>
{
    // Frame
    UILabel *_outerLine;
    UILabel *_horizontalLine;
    UILabel *_verticalLine;
    
    // Text
    UILabel *_enablePushTitle;
    UILabel *_enablePushText;
    
    //Buttons
    UIButton *_enablePushButton;
    UIButton *_cancelPushButton;
    UIButton *_startButton;
}

@end
