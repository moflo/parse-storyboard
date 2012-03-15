//
//  statusViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "statusViewController.h"

@implementation statusViewController
@synthesize purchaseButton;
@synthesize vidsRemainingText;
@synthesize table;
@synthesize objectArray;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {

        activityIndicator.hidden = NO;
        PFQuery *query = [PFQuery queryWithClassName:@"VidObject"];
        [query whereKey:@"userID" equalTo:currentUser];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // Results were successfully found, looking first on the
                // network and then on disk.
                self.objectArray = [objects copy];
                [self.table reloadData];
                activityIndicator.hidden = YES;
            } else {
                // The network was inaccessible and we have no cached data for
                // this query.
                activityIndicator.hidden = YES;
                NSLog(@"statusViewController: error retrieving VidObject array");
            }
        }];
    }
    else {
        NSLog(@"statusViewController: no user found");
    }
}


- (void) viewWillAppear:(BOOL)animated  {
    
    NSString *videosRemaining = NSLocalizedString(@"You have", @"VidCountPrefix");

    int videoCount = 0;
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //! Update view with remaining video count
        videoCount = [[currentUser objectForKey:@"videoCount"] intValue];
    }
    
    NSString *videoPostfix = NSLocalizedString(@"videos", @"VidCounter");
    
    videosRemaining = [videosRemaining stringByAppendingFormat:@" %d %@", videoCount, videoPostfix ];

    vidsRemainingText.text = videosRemaining;
    
}

- (void)viewDidUnload
{
    [self setPurchaseButton:nil];
    [self setVidsRemainingText:nil];
    [self setTable:nil];
    [self setObjectArray:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIAlertView Handling

#define	kAlertDismissOK 101
#define kAlertLogoutUser 121

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			if (alertView.tag == kAlertLogoutUser) 
			{
				//NSLog(@"kAlertDismissOK");	// placeholder
                [PFUser logOut];
                //[[self navigationController] popViewControllerAnimated:YES];
                [[self navigationController] popToRootViewControllerAnimated:YES];
                //[self viewWillAppear:YES];
			}
			break;
		default:
			break;
	}
}

- (IBAction)doPurchaseButton:(id)sender {
}

- (IBAction)doLogoutButton:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // Check whether user wants to logout or not
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account" 
                                                        message:@"Do you want to logout and switch users?"
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout",nil];
        [alert show];
        [alert setTag:kAlertLogoutUser];
        
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.objectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    PFObject *videoObject = [self.objectArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [videoObject objectId];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:videoObject.createdAt];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *videoObject = [self.objectArray objectAtIndex:indexPath.row];

    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    myApp->videoObject = videoObject;
    
    [self performSegueWithIdentifier:@"shareSegue" sender:nil];

}

@end
