//
//  FirstViewController.h
//  HelpUkraine
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController 
{
    //Buttons
    UIButton *_sendHelpButton;
    UIButton *_getHelpButton;
    UIButton *_newsButton;
    UIButton *_settingsButton;
    
    //Labels
    UILabel *_newsButtonLabel;
    UILabel *_sendHelpButtonLabel;
    UILabel *_getHelpButtonLabel;
    UILabel *_settingsButtonLabel;
    UILabel *_comingSoonLabel1;
    UILabel *_comingSoonLabel2;
}


@end