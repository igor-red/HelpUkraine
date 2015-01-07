//
//  SecondViewController.m
//  HelpUkraine
//
//  Created by Admin on 8/10/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "MainViewController.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ListTableViewCell.h"

@class ListTableViewCell;

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // White background of the View Controller
        self.view.backgroundColor = [UIColor whiteColor];

        // Initializing main TableView
        _listViewTable = [[UITableView alloc] initWithFrame:_bounds style:UITableViewStylePlain];
        _listViewTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listViewTable.dataSource = self;
        _listViewTable.delegate = self;
        [self.view addSubview:_listViewTable];
        
    }
    return self;
}

// Return one section in TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Return sorted list of contacts
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [_shortDictSorted count];
}

// Initialize cell content
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *_cellindentifier = @"ListViewCellIdentifier";
    NSDictionary *_dictionary = [_shortDictSorted objectAtIndex:[indexPath row]];
    ListTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellindentifier];
    if (_cell == nil)
    {
        _cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellindentifier];
    }
    
    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _cell._cellName.text = [_dictionary objectForKey:@"name"];
    
    // Color cell if there's a color for it in dict
    if ([[_dictionary objectForKey:@"color"] length] != 0)
    {
        NSString *_cellColorFromDict= [NSString stringWithFormat:@"0x%@", [_dictionary objectForKey:@"color"]];
        unsigned colorInt = 0;
        [[NSScanner scannerWithString:_cellColorFromDict] scanHexInt:&colorInt];
        _cell.backgroundColor = UIColorFromRGB(colorInt);
    }
    
    return _cell;
}

// Open Details View Controller for selected cell
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:_detailsViewController animated:YES];
    NSDictionary *_choiceFromListView = [_shortDictSorted objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"_choiceFromListView" object:nil userInfo:_choiceFromListView];
}

// Get contacts for the specific language and sort them before displaying
- (void)shortenDictToOneGroupAndSort:(NSNotification *) notif
{
    NSDictionary  *_choiceFromSendHelpView = notif.userInfo;
    NSString *_choiceOnSendHelpView = [_choiceFromSendHelpView objectForKey:@"_groupSelected"];
    self.title = [_choiceFromSendHelpView objectForKey:@"_groupSelectedName"];
    
    _shortDictSorted = [[NSMutableArray alloc] init];
    for (NSDictionary *_dictionary in _dictInOneLanguage)
    {
        NSString *_groupName = [_dictionary objectForKey:@"group"];
        NSString *_contactName = [_dictionary objectForKey:@"name"];
        
        if ([_groupName isEqualToString:_choiceOnSendHelpView] && ![_contactName  isEqualToString: @""])
        {
            [_shortDictSorted addObject:_dictionary];
        }
    }
    
    // Sort it
    [_shortDictSorted sortUsingDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)], nil]];
}

- (void)viewDidLoad
{
    // Receive group name from the Send Help View Controller to know contacts from which group to display
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortenDictToOneGroupAndSort:) name:@"_choiceFromSendHelpView" object:nil];
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
