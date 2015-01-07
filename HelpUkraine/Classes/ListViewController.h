//
//  SecondViewController.h
//  HelpUkraine
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"

@class ListViewController;

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // Main Table View
    UITableView *_listViewTable;
    
    // Short sorted dict of contacts
    NSMutableArray *_shortDictSorted;
}

@end

