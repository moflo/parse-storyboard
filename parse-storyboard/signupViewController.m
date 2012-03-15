//
//  signupViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "signupViewController.h"

@implementation signupViewController
@synthesize bannerImage;
@synthesize bannerRuleImage;
@synthesize userNameText;
@synthesize userEmailText;
@synthesize userPasswordText;
@synthesize userPassword2Text;
@synthesize signupButton;
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
    [self setUserEmailText:nil];
    [self setUserPasswordText:nil];
    [self setUserPassword2Text:nil];
    [self setBannerImage:nil];
    [self setBannerRuleImage:nil];
    [self setSignupButton:nil];
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

#define kAnimationDurationPush 0.30
#define kAnimationFieldVerticalOffset 74
#define kAnimationButtonVerticalOffset 195

- (IBAction)doSignupButton:(id)sender {
    
    if ([self signupPreFlightCheck]) {
        [userNameText resignFirstResponder];
        [userEmailText resignFirstResponder];
        [userPasswordText resignFirstResponder];
        [userPassword2Text resignFirstResponder];
        if (buttonMoved) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kAnimationDurationPush];
            bannerImage.center = CGPointMake(bannerImage.center.x,bannerImage.center.y+kAnimationFieldVerticalOffset);
            bannerRuleImage.center = CGPointMake(bannerRuleImage.center.x,bannerRuleImage.center.y+kAnimationFieldVerticalOffset);
            userNameText.center = CGPointMake(userNameText.center.x,userNameText.center.y+kAnimationFieldVerticalOffset);
            userEmailText.center = CGPointMake(userEmailText.center.x,userEmailText.center.y+kAnimationFieldVerticalOffset);
            userPasswordText.center = CGPointMake(userPasswordText.center.x,userPasswordText.center.y+kAnimationFieldVerticalOffset);
            userPassword2Text.center = CGPointMake(userPassword2Text.center.x,userPassword2Text.center.y+kAnimationFieldVerticalOffset);
            signupButton.center = CGPointMake(signupButton.center.x,signupButton.center.y+kAnimationButtonVerticalOffset);
            [UIView commitAnimations];
            buttonMoved = NO;
        }

        activityIndicator.hidden = NO;
        
        PFUser *user = [[PFUser alloc] init];
        user.username = userNameText.text;
        user.password = userPasswordText.text;
        user.email = userEmailText.text;
        
        // Set a default number of "free" videos available, if user hasn't registered the app already
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL didUserRegister = [[defaults objectForKey:@"userDidRegister"] boolValue];
        if (didUserRegister) {
            [user setObject:[NSNumber numberWithInt:0] forKey:@"videoCount"];
        }
        else {
            [user setObject:[NSNumber numberWithInt:INITIAL_NUMBER_FREE_CREDITS] forKey:@"videoCount"];
        }
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            activityIndicator.hidden = YES;
            if (!error) {
                // Hooray! Let them use the app now.
                // Save flag that user has registered once
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"userDidRegister"];
                [defaults synchronize];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup" 
                                                                message:@"Account created."
                                                               delegate:self 
                                                      cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
                [alert show];
                [alert setTag:kAlertDismissOK];

            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                // Show the errorString somewhere and let the user try again.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup Error" 
                                                                message:errorString
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert setTag:kAlertDismissOK];

            }
        }];
    }
}

- (BOOL) signupPreFlightCheck {
    //! Check settings field data, if valid return YES, otherwise provide error message
    BOOL preflightOK = YES;
    NSString *message = @"Please enter the following: ";
    
    
    NSRange rangeAtSign = [userEmailText.text rangeOfString:@"@"];
    NSRange rangeDot = [userEmailText.text rangeOfString:@"."];
    if ( (rangeAtSign.location == NSNotFound) || (rangeDot.location == NSNotFound) ){
        message = [message stringByAppendingString:@"\n- A valid email address"];
        preflightOK = NO;
    }
    
    if ( (![userNameText.text length]) || ([userNameText.text length]>150) ){
        message = [message stringByAppendingString:@"\n- A valid user name"];
        preflightOK = NO;
    }
    
    if ( (![userPasswordText.text length]) || ([userPasswordText.text length]>150) ){
        message = [message stringByAppendingString:@"\n- A valid password"];
        preflightOK = NO;
    }
    
    if ( ![userPasswordText.text isEqualToString:userPassword2Text.text] ){
        message = [message stringByAppendingString:@"\n- Passwords that match"];
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


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {	
	//! text input keyboard about to show
	
	if (!buttonMoved) {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kAnimationDurationPush];
		bannerImage.center = CGPointMake(bannerImage.center.x,bannerImage.center.y-kAnimationFieldVerticalOffset);
		bannerRuleImage.center = CGPointMake(bannerRuleImage.center.x,bannerRuleImage.center.y-kAnimationFieldVerticalOffset);
		userNameText.center = CGPointMake(userNameText.center.x,userNameText.center.y-kAnimationFieldVerticalOffset);
		userEmailText.center = CGPointMake(userEmailText.center.x,userEmailText.center.y-kAnimationFieldVerticalOffset);
		userPasswordText.center = CGPointMake(userPasswordText.center.x,userPasswordText.center.y-kAnimationFieldVerticalOffset);
		userPassword2Text.center = CGPointMake(userPassword2Text.center.x,userPassword2Text.center.y-kAnimationFieldVerticalOffset);
		signupButton.center = CGPointMake(signupButton.center.x,signupButton.center.y-kAnimationButtonVerticalOffset);
		[UIView commitAnimations];
		buttonMoved = YES;
	}
	
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	//! Move to next field, or dismiss keyboard
    
    if (textField == userNameText) {
		// Select the next text field
		[userEmailText becomeFirstResponder];
	}
    
    if (textField == userEmailText) {
		// Select the next text field
		[userPasswordText becomeFirstResponder];
	}
    
    if (textField == userPasswordText) {
		// Select the next text field
		[userPassword2Text becomeFirstResponder];
	}
    
    if (textField == userPassword2Text) {    
        // Dismiss the keyboard and move the button back, if needed
        [textField resignFirstResponder];
        [self doSignupButton:nil];
    }
    
	return YES;
}

@end
