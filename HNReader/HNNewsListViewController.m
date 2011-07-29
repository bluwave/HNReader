//
//  HNNewsListViewController.m
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNNewsListViewController.h"
#import "HNClient.h"
#import "HNTableViewCell.h"
#import "HNReaderAppDelegate.h"
#import "HNReaderViewController.h"

@interface HNNewsListViewController()
@property (retain, nonatomic) NSMutableArray * _newsPosts;
@property (retain, nonatomic) NSString * _nextFeedId;

-(void) getNews:(NSString*) nextId;
@end

@implementation HNNewsListViewController
@synthesize _newsPosts;
@synthesize _tableView;
@synthesize _nextFeedId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init with nib HNNewsListViewController");
    }
    return self;
}

- (void)dealloc
{
    [_nextFeedId release];
    [_tableView release];
    [_newsPosts release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._newsPosts = [NSMutableArray array];
    [self getNews:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_newsPosts count] + 1;    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    HNTableViewCell *cell =  (HNTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"HNTableViewCell" owner:nil options:nil];
        cell = [nibContents objectAtIndex:0];
    }
    
    // Configure the cell.
    if(indexPath.row == [_newsPosts count])
    {
        cell.title.text = @"...load more";
        cell.url.text = @"";
        cell.postDate.text = @"";
    }
    else
    {
        NSDictionary * dict = [_newsPosts objectAtIndex:indexPath.row];
        cell.title.text  = [NSString stringWithFormat:@"%@", [dict valueForKey:@"title"]];
        cell.url.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"url"]];
        cell.postDate.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"postedAgo"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [_newsPosts count])
    {
        [self getNews:_nextFeedId];
    }
    else
    {
        NSString * url = [[_newsPosts objectAtIndex:indexPath.row] objectForKey:@"url"];
        NSString * title = [[_newsPosts objectAtIndex:indexPath.row] objectForKey:@"title"];
        [[HNReaderAppDelegate instance].viewController showUrl:url withTitle:title];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
#pragma mark - private helpers
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    [self getNews:nil] ;
}

-(void) getNews:(NSString*) nextId
{
    HNClient * api = [[HNClient alloc] init];
    [[HNReaderAppDelegate instance] toggleSpinner:YES withView:self.view withLabel:@"Querying HN API" withDetailLabel:@"please wait..."];
    [api getNews:nextId withCompleteBlock:^(ApiResponse *resp)
     {
         
         if(resp.hasError)
         {
             [[[[UIAlertView alloc] initWithTitle:@"Api Service Unavailable" message:@"Click OK to try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
         }
         else
         {
             NSDictionary * data = [resp getDictionaryFromReceivedData];
             NSLog(@"data: %@", data);
             
             [_newsPosts addObjectsFromArray:[[data objectForKey:@"items"] copy]];
             //                 self._newsPosts = [[NSMutableArray alloc] initWithArray:[[data objectForKey:@"items"] copy]];
             self._nextFeedId = [data objectForKey:@"nextId"];
             [self._tableView reloadData];
         }
         
         [[HNReaderAppDelegate instance] toggleSpinner:NO withView:nil withLabel:nil withDetailLabel:nil];
     } ];
    [api release];
}

-(void) rotate:(UIInterfaceOrientation) orientation
{
    CGRect frame = self.view.frame;
    if( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) )
    {
        frame.size.width = 768;
        frame.size.height = 1004;
    }
    else
    {
        frame.size.width = 1024;
        frame.size.height = 748;
    }
    self.view.frame = frame;
}
@end
