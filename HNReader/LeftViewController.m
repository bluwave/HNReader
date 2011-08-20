//
//  LeftViewController.m
//  PanViews
//
//  Created by slim on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftViewController.h"
#import "UIView+Orientation.h"
#import "HNReaderAppDelegate.h"
#import "HttpResponse.h"
#import "HNClient.h"

@interface LeftViewController()
@property(retain,nonatomic) UITableView * _tableView;
@property(retain,nonatomic) NSMutableArray * _posts;
@property(retain,nonatomic) NSString* _nextId;
-(void) loadList;
@end

@implementation LeftViewController
@synthesize _tableView;
@synthesize _posts;
@synthesize _nextId;
- (void)dealloc
{
    [_nextId release];
    [_posts release];
    [_tableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
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
    
    self._posts = [NSMutableArray array];
    [self loadList];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect frame= [UIView getOrientationSizing];
    
    CGRect vFrame = self.view.frame;
    vFrame.size.width = 320;
    vFrame.size.height = frame.size.height;
    self.view.frame = vFrame;
    
    
    frame.size.width = 320;
    self._tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self._tableView.backgroundColor = [UIColor lightGrayColor];
    self._tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect frame = [UIView getOrientationSizing];
    NSLog(@"%@: %f %f", [UIView isOrienationPortait] ? @"port": @"land" ,frame.size.width, frame.size.height);
    CGRect vFrame =self.view.frame;

    vFrame.size.height= frame.size.height;
    self.view.frame = vFrame;    
    
    
//    CGRect tFrame = _tableView.frame;
//    tFrame.size.height= frame.size.height;
//    _tableView.frame = tFrame;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_posts count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(indexPath.row == [_posts count])
    {
        cell.textLabel.text = @"load more...";
    }
    else{
        
        NSDictionary * dict = [_posts objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row clicked");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == [_posts count])
    {
        [self loadList];
    }
    
//    CustomPannableA * view = [[CustomPannableA alloc] initWithNibName:@"CustomPannableA" bundle:nil];
//    [[[PanViewsAppDelegate instance] getViewManager] pushView:view]; 
    //    [view release];
}

-(void) loadList
{
    HNClient * client = [[HNClient alloc] init];
    [[HNReaderAppDelegate instance] toggleSpinner:YES withView:[[HNReaderAppDelegate instance] getBaseView]   withLabel:@"Please wait" withDetailLabel:@"Please wait......"];
    [client getPostsOfType:NEWS WithMoreId:_nextId completeBlock:^(HttpResponse *resp, NSDictionary *posts) 
     {
         if(resp.hasError)
         {
             [[[[UIAlertView alloc] initWithTitle:@"Houston we have a problem" message:@"Something went wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
         }
         else
         {
             self._nextId = [posts objectForKey:@"more"];
             [_posts addObjectsFromArray:[posts objectForKey:@"posts"] ];
//             NSLog(@"%@", _posts);
             [_tableView reloadData];
         }
     }];
    [client release];
}
@end
