//
//  RootViewController.m
//  HNReader
//
//  Created by slim on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "DetailViewController.h"
#import "HNReaderAppDelegate.h"
#import "ApiResponse.h"
#import "HNClient.h"

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize newsPosts;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.newsPosts = [NSMutableArray array];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [self getNews];
}

		
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    		
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsPosts count];
    		
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    		
    NSDictionary * dict = [newsPosts objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"title"]];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.numberOfLines = 3;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * url = [[newsPosts objectAtIndex:indexPath.row] objectForKey:@"url"];
    [[HNReaderAppDelegate instance].detailViewController setDetailItem:url];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [detailViewController release];
    [super dealloc];
}


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
            self.newsPosts = [[NSMutableArray alloc] initWithArray:[data objectForKey:@"items"]];
            [self.tableView reloadData];
        }
        
        [[HNReaderAppDelegate instance] toggleSpinner:NO withView:nil withLabel:nil withDetailLabel:nil];
    } ];
}

@end
