//
//  sendViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "selectViewController.h"


@implementation selectViewController
@synthesize table;
@synthesize list;
@synthesize filteredListContent;
@synthesize recipientNameText;
@synthesize recipientPhoneText;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
	self.list = (__bridge NSMutableArray *)CFArrayCreateMutableCopy(kCFAllocatorDefault, CFArrayGetCount(people), people);
    CFArraySortValues((__bridge CFMutableArrayRef)self.list,
                      CFRangeMake(0, [self.list count]),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void *)kABPersonSortByLastName);
	[table reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setList:nil];
    [self setRecipientNameText:nil];
    [self setRecipientPhoneText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    
    if (videoObject) {
        
        NSString *firstName = [videoObject objectForKey:@"receiverFirstName"];
        NSString *lastName = [videoObject objectForKey:@"receiverLastName"];
        NSString *mobilePhone = [videoObject objectForKey:@"receiverMobilePhone"];
        
        [recipientNameText setText:[NSString stringWithFormat:@"%@ %@",firstName, lastName]];
        if (!firstName) {
            [recipientNameText setText:lastName];
        }
        if (!lastName) {
            [recipientNameText setText:firstName];
        }
        if (!lastName & !firstName) {
            [recipientNameText setText:@"Select below"];
        }

        [recipientPhoneText setText:mobilePhone];
        
    }

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	ABRecordRef person;
	//! Assign status object depending on whether a search is being conducted
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		person = (__bridge ABRecordRef)[self.filteredListContent objectAtIndex:indexPath.row];
	}
	else {
		person = (__bridge ABRecordRef)[self.list objectAtIndex:indexPath.row];
	}
	
	NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	if (firstName && lastName) {
		cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",lastName,firstName];
	}
	if (!firstName) {
		cell.textLabel.text = lastName;
	}
	if (!lastName) {
		cell.textLabel.text = firstName;
	}
	cell.detailTextLabel.text = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	if (ABPersonHasImageData(person)) {
		cell.imageView.image = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(person)];
	}
	else {
		cell.imageView.image = [UIImage imageNamed:@"User_Icon.png"];
	}
    
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
    ABRecordRef person;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		person = (__bridge ABRecordRef)[filteredListContent objectAtIndex:indexPath.row];
	} 
	else {
		person = (__bridge ABRecordRef)[self.list objectAtIndex:indexPath.row];
	}

    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;

    if (videoObject) {
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *telMobile, *telOffice, *telHome;
        ABMutableMultiValueRef multi; //= ABMultiValueCreateMutable(kABMultiStringPropertyType);
        multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
            //CFStringRef phoneNumberLabel = ABMultiValueCopyLabelAtIndex(multi, i);
            NSString *phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, i);
            if (i==0) { telMobile = phoneNumber; }
            if (i==1) { telOffice = phoneNumber; }
            if (i==2) { telHome = phoneNumber; }
        }
        
        NSString *emailWork;
        multi = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(multi); i++) {
            //CFStringRef phoneNumberLabel = ABMultiValueCopyLabelAtIndex(multi, i);
            NSString *emailAddress = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, i);
            if (i==0) { emailWork = emailAddress; }
        }
        
        if (firstName) { [videoObject setObject:firstName forKey:@"receiverFirstName"]; }
        if (lastName) { [videoObject setObject:lastName forKey:@"receiverLastName"]; }
        if (telMobile) { [videoObject setObject:telMobile forKey:@"receiverMobilePhone"]; }
        if (emailWork) { [videoObject setObject:emailWork forKey:@"receiverEmailWork"]; }

    }
    
    [self viewWillAppear:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ABPersonViewController *view = [[ABPersonViewController alloc] init];
	view.personViewDelegate = self;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		view.displayedPerson = (__bridge ABRecordRef)[filteredListContent objectAtIndex:indexPath.row];
	} 
	else {
		view.displayedPerson = (__bridge ABRecordRef)[self.list objectAtIndex:indexPath.row];
	}
	
	[self.navigationController pushViewController:view animated:YES];

}

#pragma ABRecordDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    return NO;
}


@end
