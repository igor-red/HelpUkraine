//
//  DetailsViewController.m
//  HelpUkraine
//
//  Created by Admin on 8/16/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "DetailsViewController.h"
#import "ListViewController.h"
#import "DetailsTableViewCell.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "WebViewController.h"


@class DetailsTableViewCell;

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Setting white background and navigation controller title
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = NSLocalizedString(@"detilsViewNavigationTitle", nil);
        
        // Initializing TableView
        _detailsViewTable = [[UITableView alloc] initWithFrame:_bounds style:UITableViewStylePlain];
        _detailsViewTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailsViewTable.delegate = self;
        _detailsViewTable.dataSource = self;
         [self.view addSubview:_detailsViewTable];
    }
    return self;
}

// Setting number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Setting number of rows
- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [_detailsOrder count];
}


// Removing empty key-pair values before showing them
- (void) removeEmptyCells:(NSNotification *) notif
{
    _detailsOrder = [_detailsOrderFromDict mutableCopy];
    _detailsTitles = [_detailsTitlesFromDict mutableCopy];
    
    // Remove keys without values
    _choiceOnListView = [notif.userInfo mutableCopy];
    NSArray *_emptyValues = [_choiceOnListView allKeysForObject:@""];
    [_choiceOnListView removeObjectsForKeys:_emptyValues];
    
    // Find if keys are not present
    NSMutableArray *_emptyValues2 = [_emptyValues mutableCopy];
        for (NSString *_details in _detailsOrder)
            if (![notif.userInfo objectForKey:_details])
                [_emptyValues2 addObject:_details];
    
    // And remove them
    for (NSString *_emptyValue in _emptyValues2)
        if ([_detailsOrder containsObject:_emptyValue])
        {
            NSInteger i = [_detailsOrder indexOfObject: _emptyValue];
            [_detailsOrder removeObjectAtIndex:i];
            [_detailsTitles removeObjectAtIndex:i];
            
        }
}

// Initializing cell content
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *_cellindentifier = @"DetailsViewCellIdentifier";
    
    // Initializing custom cell
    DetailsTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:_cellindentifier];
    if (_cell == nil) {
        _cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellindentifier];
    }
    
    // Setting cell's title and details
    _cell._cellTitle.text = _detailsTitles[indexPath.row];
    _cell._cellDetails.text = [_choiceOnListView objectForKey:_detailsOrder[indexPath.row]];
    
    // Calculating details text height
    CGFloat _height = [self textHeight:_cell._cellDetails.text withDetailsKey:_detailsOrder[indexPath.row]];
    if (_height == 44)
        _height = 22;
    
    // Assuming there wouldn't be any icon in the cell
    _iconWidth = 0;
    
    // Cusomizing the 'phone' cell view
    if ([_detailsOrder[indexPath.row] isEqualToString: @"phone"])
    {
        _cell._cellIcon.image = [UIImage imageNamed:@"detailsViewPhone.png"];
        _height = 22;
        _iconWidth = 30;
        [_cell._cellDetails setNumberOfLines:1];
        _cell._cellDetails.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    // Cusomizing the 'website' cell view
    if ([_detailsOrder[indexPath.row] isEqualToString: @"website"])
    {
        _height = 22;
        _iconWidth = 30;
        _cell._cellIcon.image = [UIImage imageNamed:@"detailsViewWebsite.png"];
        [_cell._cellDetails setNumberOfLines:1];
        _cell._cellDetails.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    // Cusomizing the 'email' cell view
    if ([_detailsOrder[indexPath.row] isEqualToString: @"email"])
    {
        _height = 22;
        _iconWidth = 30;
        _cell._cellIcon.image = [UIImage imageNamed:@"detailsViewEmail.png"];
        [_cell._cellDetails setNumberOfLines:1];
        _cell._cellDetails.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    // Resetting the cell details frame according to our prior calculations
    _cell._cellDetails.frame = CGRectMake(15, 20, _bounds.size.width - 15 - _iconWidth, _height);
    
    // Returning cell
    return _cell;
}


// Measuring cell height for every cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat _height = [self textHeight:[_choiceOnListView objectForKey:_detailsOrder[indexPath.row]] withDetailsKey:@""];
    if ([_detailsOrder[indexPath.row] isEqualToString:@"website"])
        _height = 22;
    if (_height == 22)
        return _height + 22;
    else return _height + 25;
}

// Measuring text height for every cell
- (CGFloat)textHeight: (NSString *) _text withDetailsKey:(NSString *) _detailsKey
{
    CGSize _maxSize = CGSizeMake(_bounds.size.width-30, MAXFLOAT);
    CGRect _labelRect = [_text boundingRectWithSize:_maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat _height = MAX(_labelRect.size.height, 22.0f);
    if ([_detailsKey isEqualToString:@"website"])
        _height = 22;
    return _height;
}


// Actions when selecting cell
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    // Disable the highlight
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Make a call if 'phone' was tapped
    if ([indexPath row] == [_detailsOrder indexOfObject:@"phone"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [_choiceOnListView valueForKey:@"phone"]]]];
    }
    
    // Open a webpage if 'website' was tapped
    if ([indexPath row] == [_detailsOrder indexOfObject:@"website"])
    {
        _previousViewControllerName = @"DetailsViewController";
        [self.navigationController pushViewController:_webViewController animated:YES];
        NSURL *_url = [NSURL URLWithString:[_choiceOnListView objectForKey:_detailsOrder[indexPath.row]]];
        NSDictionary *_webLink = [NSDictionary dictionaryWithObject:_url forKey:@"_webLink"];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"_webLink" object:nil userInfo:_webLink];
    }
    
    // Compose an email if 'email' was tapped
    if ([indexPath row] == [_detailsOrder indexOfObject:@"email"])
    {
        NSString *_selectedEmail = [_choiceOnListView objectForKey:_detailsOrder[indexPath.row]];
        [self openMail:_selectedEmail];
    }
}

// Compose email modal view
- (void)openMail: (NSString*)email
{
    // If an email account is set
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *_mailWindow = [[MFMailComposeViewController alloc] init];
        _mailWindow.mailComposeDelegate = self;
        [_mailWindow setSubject:NSLocalizedString(@"emailSubject", nil)];
        NSArray *_recipients = [NSArray arrayWithObjects:email, nil];
        [_mailWindow setToRecipients: _recipients];
        NSString *emailBody = [[NSString alloc] initWithFormat:@"\n\n%@", NSLocalizedString(@"emailBody", nil) ];
        [_mailWindow setMessageBody:emailBody isHTML:NO];
        [self presentViewController:_mailWindow animated:YES completion:nil];
    }
    // If no email accounts are set
    else
    {
        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"noComposer", nil)
                                                        message:NSLocalizedString(@"enableEmail", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles: nil];
        [_alert show];
    }
}

// Result of the interaction with the email composer
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    #ifdef DEBUG
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    #endif
    
    // Remove the modal view
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Allowing longpress on cells
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// To copy what's in them
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

// Actual copy method from the cell to the pasteboard
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        UIPasteboard *_pasteboard = [UIPasteboard generalPasteboard];
        NSString *_pasteString = [_choiceOnListView objectForKey:_detailsOrder[indexPath.row]];
        _pasteboard.string = _pasteString;
    }
}

- (void)viewDidLoad
{
    // Adding an notification observer to catch the choice on the List View
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEmptyCells:) name:@"_choiceFromListView" object:nil];
    [super viewDidLoad];
    
    // Registering for a custom cell
    [_detailsViewTable registerClass:[DetailsTableViewCell class] forCellReuseIdentifier:@"DetailsCellIdentifier"];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Updating the height of the table depending on its content size
    _detailsViewTable.contentSize = CGSizeMake(_bounds.size.width, _detailsViewTable.contentSize.height);
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
