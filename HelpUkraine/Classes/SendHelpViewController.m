//
//  GroupsViewController.m
//  HelpUkraine
//
//  Created by Admin on 8/23/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "SendHelpViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ListViewController.h"
#import "SendHelpTableViewCell.h"

@class SendHelpTableViewCell;

@interface SendHelpViewController ()

@end

@implementation SendHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        // Setting up correct Navigation Title
        self.title = NSLocalizedString(@"sendHelpViewNavigationTitle", nil);
        
        // Initializing the resulting sorted array of dictinaries
        _sendHelpTableGroupSorted = [[NSMutableArray alloc] init];
        NSMutableArray *_sendHelpTableGroupOrdersCopy = [_sendHelpTableGroupOrders mutableCopy];
        
        // Filling the resulting array with dicts that contain all of the groups meta
        for (NSInteger i = 0; i < [_sendHelpTableGroupTitles count]; i++)
        {
            if ([_sendHelpTableGroupOrdersCopy[i] length] == 0)
                [_sendHelpTableGroupOrdersCopy replaceObjectAtIndex:i withObject:@"999"];
            [_sendHelpTableGroupSorted addObject:[[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects:_sendHelpTableGroupOrdersCopy[i], _sendHelpTableGroupTitles[i], [NSNumber numberWithInteger:i], _sendHelpTableGroupColors[i], _sendHelpTableGroupTypes[i], nil] forKeys: [NSArray arrayWithObjects:@"groupOrder", @"groupName", @"groupIndex", @"groupColor", @"groupType", nil]]];
        }
        
        // Sort it
        [_sendHelpTableGroupSorted sortUsingDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"groupOrder" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"groupName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], nil]];

        // Initializing the main TableView
        _sendHelpTableView = [[UITableView alloc] initWithFrame:_bounds style:UITableViewStylePlain];
        _sendHelpTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _sendHelpTableView.dataSource = self;
        _sendHelpTableView.delegate = self;
        [self.view addSubview:_sendHelpTableView];
        
    }
    return self;
}

// Return one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return group amount of rows
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [_sendHelpTableGroupTypes count];
}

// Initializing cell content
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *_cellindentifier = @"SendHelpViewCellIdentifier";
    SendHelpTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellindentifier];
    if (_cell == nil)
    {
        _cell = [[SendHelpTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellindentifier];
    }
    
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _cell._cellName.text = [_sendHelpTableGroupSorted[indexPath.row] objectForKey:@"groupName"];
    
    // Setting cell color if present in dict
    if ([[_sendHelpTableGroupSorted[indexPath.row] objectForKey:@"groupColor"] length] != 0)
    {
        NSString *_groupColor= [NSString stringWithFormat:@"0x%@", [_sendHelpTableGroupSorted[indexPath.row] objectForKey:@"groupColor"]];
        unsigned colorInt = 0;
        [[NSScanner scannerWithString:_groupColor] scanHexInt:&colorInt];
        
        _cell.backgroundColor=UIColorFromRGB(colorInt);
    }
    
    return _cell;
    
}

// Opening ListView for selected cell (group)
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:_listViewController animated:YES];
    NSString *_groupSelected = [_sendHelpTableGroupSorted[indexPath.row] objectForKey:@"groupType"];
    NSString *_groupSelectedName = [_sendHelpTableGroupSorted[indexPath.row] objectForKey:@"groupName"];
    NSDictionary *_choiceFromSendHelpView = [[NSDictionary alloc] initWithObjectsAndKeys:_groupSelected, @"_groupSelected", _groupSelectedName, @"_groupSelectedName", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"_choiceFromSendHelpView" object:nil userInfo:_choiceFromSendHelpView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
