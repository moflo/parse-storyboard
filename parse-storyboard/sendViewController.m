//
//  sendViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "sendViewController.h"
#import "Parse/Parse.h"

@implementation sendViewController
@synthesize recipientName;

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
        
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setRecipientName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewWillAppear:(BOOL)animated  {
    
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    
    if (videoObject) {
        //! Update recipient lable with video infomation
        NSString *firstName = [videoObject objectForKey:@"receiverFirstName"];
        NSString *lastName = [videoObject objectForKey:@"receiverLastName"];
        
        [recipientName setText:[NSString stringWithFormat:@"%@ %@",firstName, lastName]];
        if (!firstName) {
            [recipientName setText:lastName];
        }
        if (!lastName) {
            [recipientName setText:firstName];
        }
        if (!lastName & !firstName) {
            [recipientName setText:@"No recipient"];
        }

    }
    
}

#pragma mark UIAlertView Handling

#define	kAlertDismissOK 101
#define kAlertPreflightFailed 103

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			if (alertView.tag == kAlertDismissOK) 
			{
				//NSLog(@"kAlertDismissOK");	// placeholder
			}
			break;
		default:
			break;
	}
}

- (void) showErrorMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" 
                                                    message:message
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert setTag:kAlertDismissOK];
    
}

- (IBAction)doConfirmButton:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        [self showErrorMessage:@"Need to register first!"];
        return;
    }

    [self performSegueWithIdentifier:@"confirmSegue" sender:sender];
}


@end
