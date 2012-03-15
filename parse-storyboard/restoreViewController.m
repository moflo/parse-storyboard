//
//  restoreViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/22/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "restoreViewController.h"
#import "Parse/Parse.h"

@implementation restoreViewController
@synthesize userEmailText;
@synthesize resetButton;

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
    [self setUserEmailText:nil];
    [self setResetButton:nil];
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
		case 0:
			if (alertView.tag == kAlertDismissOK) 
			{
				//NSLog(@"kAlertDismissOK");	// placeholder
                //[[self navigationController] popViewControllerAnimated:YES];
                [[self navigationController] popToRootViewControllerAnimated:YES];
			}
			break;
		default:
			break;
	}
}


- (IBAction)doResetButton:(id)sender {
    
    if ([self resetPreFlightCheck]) {

        [PFUser requestPasswordResetForEmailInBackground:userEmailText.text];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passsword Reset" 
                                                        message:@"Please check your email to reset your password"
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert setTag:kAlertDismissOK];
    }
}

- (BOOL) resetPreFlightCheck {
    //! Check settings field data, if valid return YES, otherwise provide error message
    BOOL preflightOK = YES;
    NSString *message = @"Please enter the following: ";
    
    
    NSRange rangeAtSign = [userEmailText.text rangeOfString:@"@"];
    NSRange rangeDot = [userEmailText.text rangeOfString:@"."];
    if ( (rangeAtSign.location == NSNotFound) || (rangeDot.location == NSNotFound) ){
        message = [message stringByAppendingString:@"\n- A valid email address"];
        preflightOK = NO;
    }
    
    if ( (![userEmailText.text length]) || ([userEmailText.text length]>150) ){
        message = [message stringByAppendingString:@"\n- A valid email address"];
        preflightOK = NO;
    }
    
    
    if (!preflightOK) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Problem" 
                                                        message:message
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert setTag:kAlertPreflightFailed];
    }
    
    return preflightOK;
}

#define kAnimationDurationPush 0.30
#define kAnimationButtonVerticalOffset 148

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {	
	//! text input keyboard about to show
	
	if (!buttonMoved) {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kAnimationDurationPush];
		CGPoint center = resetButton.center;
		resetButton.center = CGPointMake(center.x,center.y-kAnimationButtonVerticalOffset);
		[UIView commitAnimations];
		buttonMoved = YES;
	}
	
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	//! Move to next field, or dismiss keyboard
	
    // Dismiss the keyboard and move the button back, if needed
    [textField resignFirstResponder];
    if (buttonMoved) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kAnimationDurationPush];
        CGPoint center = resetButton.center;
        resetButton.center = CGPointMake(center.x,center.y+kAnimationButtonVerticalOffset);
        [UIView commitAnimations];
        buttonMoved = NO;
    }
    [self doResetButton:nil];

    
	return YES;
}

@end
