//
//  accountViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "accountViewController.h"
#import "Parse/Parse.h"

@implementation accountViewController
@synthesize userNameText;
@synthesize userPasswordText;
@synthesize loginButton;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        buttonMoved = NO;
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setUserNameText:nil];
    [self setUserPasswordText:nil];
    [self setLoginButton:nil];
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

#define kAnimationDurationPush 0.30
#define kAnimationButtonVerticalOffset 108


- (IBAction)doLoginButton:(id)sender {
    
    if ([self loginPreFlightCheck]) {
        [userNameText resignFirstResponder];
        [userPasswordText resignFirstResponder];
        if (buttonMoved) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:kAnimationDurationPush];
			CGPoint center = loginButton.center;
			loginButton.center = CGPointMake(center.x,center.y+kAnimationButtonVerticalOffset);
			[UIView commitAnimations];
			buttonMoved = NO;
		}
        activityIndicator.hidden = NO;
        [PFUser logInWithUsernameInBackground:userNameText.text password:userPasswordText.text 
                                        block:^(PFUser *user, NSError *error) {
                                            activityIndicator.hidden = YES;
                                            if (user) {
                                                // do stuff after successful login.
                                                //[[self navigationController] popViewControllerAnimated:YES];
                                                [[self navigationController] popToRootViewControllerAnimated:YES];
                                            } else {
                                                // the username or password is invalid. 
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" 
                                                                                                message:@"User or password was incorrect"
                                                                                               delegate:self 
                                                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [alert show];
                                                [alert setTag:kAlertDismissOK];
                                                

                                            }
                                        }];
    }

}

- (BOOL) loginPreFlightCheck {
    //! Check settings field data, if valid return YES, otherwise provide error message
    BOOL preflightOK = YES;
    NSString *message = @"Please enter the following: ";
    
    
    if ( (![userNameText.text length]) || ([userNameText.text length]>150) ){
        message = [message stringByAppendingString:@"\n- A valid user name"];
        preflightOK = NO;
    }
    
    if ( (![userPasswordText.text length]) || ([userPasswordText.text length]>150) ){
        message = [message stringByAppendingString:@"\n- Valid password"];
        preflightOK = NO;
    }
    
    
    if (!preflightOK) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Problem" 
                                                        message:message
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert setTag:kAlertPreflightFailed];
    }
    
    return preflightOK;
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {	
	//! text input keyboard about to show
	
	if (!buttonMoved) {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kAnimationDurationPush];
		CGPoint center = loginButton.center;
		loginButton.center = CGPointMake(center.x,center.y-kAnimationButtonVerticalOffset);
		[UIView commitAnimations];
		buttonMoved = YES;
	}
	
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	//! Move to next field, or dismiss keyboard
	
	if (textField == userNameText) {
		// Select the next text field
		[userPasswordText becomeFirstResponder];
	}
    
	if (textField == userPasswordText) {
		// Dismiss the keyboard and move the button back, if needed
		[textField resignFirstResponder];
        [self doLoginButton:nil];
	}
	return YES;
}

@end
