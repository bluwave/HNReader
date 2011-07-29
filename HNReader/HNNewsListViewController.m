//
//  HNNewsListViewController.m
//  HNReader
//
//  Created by slim on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HNNewsListViewController.h"
#import "HNClient.h"

#import "HNReaderAppDelegate.h"

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
    NSLog(@"posts: %d", [_newsPosts count]);
    return [_newsPosts count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    
    NSDictionary * dict = [_newsPosts objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"title"]];
    cell.textLabel.font = [UIFont systemFontOfSize:11];
//    cell.textLabel.numberOfLines = 3;
//    NSLog(@"title: %@", cell.textLabel.text);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString * url = [[newsPosts objectAtIndex:indexPath.row] objectForKey:@"url"];
    //    [[HNReaderAppDelegate instance].detailViewController setDetailItem:url];
    
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
    NSLog(@"list view rotate");
    CGRect frame = self.view.frame;
    if( [[HNReaderAppDelegate instance] isOrientationPortrait] )
    {
        frame.size.width = 320;
        frame.size.height = 1004;
    }
    else
    {
        frame.size.width = 320;
        frame.size.height = 748;   
    }
    self.view.frame = frame;
}
@end
