//
//  LeftViewController.m
//  PanViews
//
//  Created by slim on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftViewController.h"
#import "UIView+Orientation.h"
#import "UIColor+HNColors.h"
#import "HNReaderAppDelegate.h"
#import "ViewManager.h"




#define kMAXWIDTH 320  

@interface LeftViewController()
@property(retain,nonatomic) UITableView * _tableView;
@property(retain,nonatomic) NSMutableArray * _menu;
//-(void) loadList;
@end

@implementation LeftViewController
@synthesize _tableView;
@synthesize _menu;

- (void)dealloc
{
    [_menu release];
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
    
    self._menu  = [NSMutableArray arrayWithObjects:@"News", @"New", @"Comments",@"Saved",@"Settings", nil];
    

    CGRect frame= [UIView getOrientationSizing];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg.png"]];
    CGRect vFrame = self.view.frame;
    vFrame.size.width = kMAXWIDTH;
    vFrame.size.height = frame.size.height;
    self.view.frame = vFrame;
    
    
    
    
    
    frame.size.width = kMAXWIDTH;
    self._tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    self._tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return [_menu count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"row_borders_on.png"]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_menu objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor HNBlue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row clicked");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[[HNReaderAppDelegate instance] getViewManager] openView:0];
}
@end
