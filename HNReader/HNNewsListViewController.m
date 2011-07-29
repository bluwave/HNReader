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

-(void) getNews;
@end

@implementation HNNewsListViewController
@synthesize _newsPosts;
@synthesize _tableView;
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
    [self getNews];
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
    return [_newsPosts count];    
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
    
    NSDictionary * dict = [_newsPosts objectAtIndex:indexPath.row];
    cell.title.text  = [NSString stringWithFormat:@"%@", [dict valueForKey:@"title"]];
    cell.url.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"url"]];
    cell.postDate.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"postedAgo"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * url = [[_newsPosts objectAtIndex:indexPath.row] objectForKey:@"url"];
    [[HNReaderAppDelegate instance].viewController showUrl:url];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - private helpers
-(void) getNews
{
    HNClient * api = [[HNClient alloc] init];
    [[HNReaderAppDelegate instance] toggleSpinner:YES withView:self.view withLabel:@"testing..." withDetailLabel:@"please wait..."];
    [api getNews:nil withCompleteBlock:^(ApiResponse *resp)
     {
         
         if(resp.hasError)
         {
             [[[[UIAlertView alloc] initWithTitle:@"Error title" message:resp.errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
         }
         else
         {
             NSDictionary * data = [resp getDictionaryFromReceivedData];
             NSLog(@"data: %@", data);
             self._newsPosts = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"items"]];
             [self._tableView reloadData];
         }
         
         [[HNReaderAppDelegate instance] toggleSpinner:NO withView:nil withLabel:nil withDetailLabel:nil];
     } ];
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
