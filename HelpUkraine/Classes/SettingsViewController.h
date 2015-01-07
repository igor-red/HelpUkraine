//
//  SettingsViewController.h
//  HelpUkraine
//
//  Created by Admin on 9/13/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // Views
    UIView *_generalGroupView;
    UIView *_databaseGroupView;
    
    // Labels
    UILabel *_generalGroupLabel;
    UILabel *_databaseGroupLabel;
    UILabel *_infoGroupLabel;
    UILabel *_notificationsSwitcherLabel;
    UILabel *_languagesSwitcherLabel;
    UILabel *_horizontalLine;
    UILabel *_horizontalLine2;
    UILabel *_databaseStatusLabel;
    
    // Switchers
    UISwitch *_notificationsSwitcher;
    UISegmentedControl *_languageSwitcher;
    UIButton *_reloadDatabaseButton;
    
    // Small TableView in the end
    UITableView *_infoGroupTable;
    NSArray *_infoGroupTableRows;
    
    // Check if database is updating
    BOOL _databaseIsUpdating;
}

- (void) databaseStopUpdating;


@end
