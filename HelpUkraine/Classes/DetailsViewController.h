//
//  DetailsViewController.h
//  HelpUkraine
//
//  Created by Admin on 8/16/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "MainViewController.h"
#import "MessageUI/MessageUI.h"

@interface DetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    // Main TableView
    UITableView *_detailsViewTable;
    
    // What was chosen on the List View
    NSMutableDictionary *_choiceOnListView;
    
    // Cell order and titles from the dict
    NSMutableArray *_detailsOrder;
    NSMutableArray *_detailsTitles;
    
    // Icon width
    CGFloat _iconWidth;
}


@end
