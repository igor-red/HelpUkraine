//
//  GroupsViewController.h
//  HelpUkraine
//
//  Created by Admin on 8/23/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendHelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dict;
    NSMutableArray *_sendHelpTableGroupSorted;
    UITableView *_sendHelpTableView;
}

@end
