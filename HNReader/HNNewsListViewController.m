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
#import "SavedStory.h"
#import "DataManager.h"
#import "HNStoryDetailViewController.h"



@interface HNNewsListViewController()
@property (retain, nonatomic) NSMutableArray * _newsPosts;
@property (retain, nonatomic) NSString * _nextFeedId;
@property (retain, nonatomic) NSArray * _savedPosts;
@property(retain, nonatomic) DataManager * _dataMan;



-(void) getNews:(NSString*) nextId;
-(BOOL) isValidUrl:(NSString * ) url;
-(void) refreshSaved;
@end

@implementation HNNewsListViewController
@synthesize _newsPosts;
@synthesize _tableView;
@synthesize _nextFeedId;
@synthesize _savedPosts;
@synthesize _dataMan;

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

    [_dataMan release];
    [_savedPosts release];
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
    self._dataMan  = [[DataManager alloc] init];
    [self getNews:nil];
    
    
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidLoad");
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewDidAppear");
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

#pragma mark - public 

-(void) reload
{
    self._nextFeedId = nil;
    self._newsPosts = [NSMutableArray array];
    [_tableView reloadData];
    [self getNews:nil];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [_newsPosts count];
    NSLog(@"_newsPosts count: %d", [_newsPosts count]);
    if (_viewState == FRONTPAGE) 
        count++;
    return count;
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
        cell.star.hidden = YES;
    }
    else
    {
        cell.star.hidden = NO;
        cell.star.delegate= self;
        cell.star.tag = indexPath.row;
        
        NSDictionary * dict = [_newsPosts objectAtIndex:indexPath.row];
        NSString * url = [dict valueForKey:@"url"];
        NSPredicate * filter = [NSPredicate predicateWithFormat:@" url == %@ ", url];
        NSArray * contains = [_savedPosts filteredArrayUsingPredicate:filter];
        if([contains count] > 0)
            [cell.star toggleChecked:YES];
        
        cell.title.text  = [NSString stringWithFormat:@"%@", [dict valueForKey:@"title"]];
        cell.url.text = [self isValidUrl:url ] ? [NSString stringWithFormat:@"%@", url] : @"[ comments ]";
        cell.postDate.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"postedAgo"]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [_newsPosts count] )
    {
        [self getNews:_nextFeedId];
    }
    else
    {
        NSDictionary * dict= [_newsPosts objectAtIndex:indexPath.row];
        NSString * url = [dict objectForKey:@"url"];
        if([self isValidUrl:url])
        {
            NSString * title = [dict objectForKey:@"title"];
            HNStoryDetailViewController * detail = [[HNStoryDetailViewController alloc] initWithNibName:@"HNStoryDetailViewController" bundle:nil];
            [[HNReaderAppDelegate instance].viewController pushView:detail];
            [detail slideInWithUrl:url withTitle:title];
            detail.delegate = self;
            
        }        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction) segmentIndexChanged:(id)sender
{
    UISegmentedControl * seg = (UISegmentedControl *) sender;
    int index = seg.selectedSegmentIndex;
    _viewState = index;
    switch (index) {
        case FRONTPAGE:
            self._nextFeedId = nil;
            self._newsPosts = [NSMutableArray array];
            [self getNews:_nextFeedId];
            break;
        case NEW:
            break;
        case SAVED:
            [self refreshSaved];
            self._newsPosts = [_savedPosts mutableCopy];
            [_tableView reloadData];
            break;
    }
}


#pragma mark - private helpers
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self getNews:_nextFeedId] ;            
            break;
    }

}

-(void) getNews:(NSString*) nextId
{
    HNClient * api = [[HNClient alloc] init];
    [[HNReaderAppDelegate instance] toggleSpinner:YES withView:self.view withLabel:@"Querying HN API" withDetailLabel:@"please wait..."];
    [api getNews:nextId withCompleteBlock:^(ApiResponse *resp)
     {
         
         if(resp.hasError)
         {
             [[[[UIAlertView alloc] initWithTitle:@"Api Service Unavailable" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil] autorelease] show];
         }
         else
         {
             NSDictionary * data = [resp getDictionaryFromReceivedData];
//             NSLog(@"data: %@", data);

             [_newsPosts addObjectsFromArray:[[data objectForKey:@"items"] copy]];
             //                 self._newsPosts = [[NSMutableArray alloc] initWithArray:[[data objectForKey:@"items"] copy]];
             self._nextFeedId = [data objectForKey:@"nextId"];
             [self refreshSaved];
             [self._tableView reloadData];
         }
         
         [[HNReaderAppDelegate instance] toggleSpinner:NO withView:nil withLabel:nil withDetailLabel:nil];
     } ];
    [api release];
}

-(void) rotate:(UIInterfaceOrientation) orientation
{
    CGRect frame = self.view.frame;
    if( [[HNReaderAppDelegate instance] isOrientationPortrait])
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
-(BOOL) isValidUrl:(NSString * ) url
{
    NSString *hasProtocol = @"http";
    NSRange range = [url rangeOfString : hasProtocol];
    return (range.location == NSNotFound) ? NO : YES;

}

-(void) HNStarButton:(HNStarButton *)button toggled:(BOOL)isChecked
{
    NSDictionary * post = [_newsPosts objectAtIndex:button.tag];
    if( isChecked )
    {
        [_dataMan savePost:post];
    }
    else
    {
        [_dataMan deletePost: [post objectForKey:@"url"]  ];
        [self refreshSaved];
        self._newsPosts = [_savedPosts mutableCopy];
        
        [_tableView reloadData];

    }
//    [self refreshSaved];
}

-(void) refreshSaved
{
    self._savedPosts = [_dataMan getSavedPosts];
}
@end
