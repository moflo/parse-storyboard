//
//  shareViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/25/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "shareViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation shareViewController
@synthesize accountButton;
@synthesize shareURLText;
@synthesize nextButton;

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
    
    [nextButton.layer setCornerRadius:8.0f];
    [nextButton.layer setMasksToBounds:YES];

}

-(NSString *)videoSharingURL {
    NSString *urlString = @"http://";
    
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    
    if (videoObject) {
        //! Update view with video infomation

#if USE_LOCAL_SERVER
    urlString = [urlString stringByAppendingFormat:@"%@%@",LOCAL_SERVER_NAME,[videoObject objectId]];
#else
    urlString = [urlString stringByAppendingFormat:@"%@%@",GLOBAL_SERVER_NAME,[videoObject objectId]];
#endif
    }
    
    return urlString;
}

- (void) viewWillAppear:(BOOL)animated  {
    
    shareURLText.text = [self videoSharingURL];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //! Display current user's name
        [self.accountButton setTitle:currentUser.username forState:UIControlStateNormal];
        [self.accountButton setTitle:currentUser.username forState:UIControlStateHighlighted];
        
    } else {
        //! Display default text
        NSString *accountName = NSLocalizedString(@"acount", @"Account");
        [self.accountButton setTitle:accountName forState:UIControlStateNormal];
        [self.accountButton setTitle:accountName forState:UIControlStateHighlighted];
    }
    
}

- (void)viewDidUnload
{
    [self setAccountButton:nil];
    [self setShareURLText:nil];
    [self setNextButton:nil];
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
#define kAlertLoginUser 120
#define kAlertLogoutUser 121
#define kAlertOpenSafari 122

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			if (alertView.tag == kAlertLoginUser) 
			{
                [self performSegueWithIdentifier:@"accountSegue" sender:nil];
			}
			if (alertView.tag == kAlertLogoutUser) 
			{
				//NSLog(@"kAlertDismissOK");	// placeholder
                [PFUser logOut];
                //[[self navigationController] popViewControllerAnimated:YES];
                //[[self navigationController] popToRootViewControllerAnimated:YES];
                [self viewWillAppear:YES];
			}
            if (alertView.tag == kAlertOpenSafari)
            {
                MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
                PFObject *videoObject = myApp->videoObject;
                if (videoObject) {
                    //! Update view with video infomation
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self videoSharingURL]]];
                }

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

- (IBAction)doOpenURLButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" 
                                                    message:@"Open this link in Safari?"
                                                   delegate:self 
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"Safari",nil];
    [alert setTag:kAlertOpenSafari];
    [alert show];
}

- (IBAction)doSendSMSButton:(id)sender {
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    if (videoObject) {
        //! Update view with video infomation
        [self displayComposerSheet:[self videoSharingURL]];
    }
}

- (IBAction)doSendEmailButton:(id)sender {
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    if (videoObject) {
        //! Update view with video infomation
        [self displayComposerSheetEmail:[self videoSharingURL]];
    }
}

- (IBAction)doAccountButton:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        // Check whether user wants to logout or not
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account" 
                                                        message:@"You need to login first."
                                                       delegate:self 
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login",nil];
        [alert show];
        [alert setTag:kAlertLoginUser];
        
    }
    else {
        [self performSegueWithIdentifier:@"statusSegue" sender:sender];
    }
}

- (IBAction)doHomeButton:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}


-(void)displayComposerSheet:(NSString *)url
{
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        //picker.delegate = self;
        [picker setMessageComposeDelegate:self];

        MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
        PFObject *videoObject = myApp->videoObject;
        if (videoObject) {
            
            // Set up the recipients.
            /***
            NSString *mobilePhone = [videoObject objectForKey:@"receiverMobilePhone"];
            NSArray *toRecipients = [NSArray arrayWithObjects:mobilePhone, nil];
            [picker setRecipients:toRecipients];
            ***/
            
            NSString *body = NSLocalizedString(@"Here's a video for you, click here:\n", @"SMSPreamble");
            body = [body stringByAppendingFormat:@"%@",url];
            [picker setBody:body];
            
            
            // Present the mail composition interface.
            [self presentModalViewController:picker animated:YES];
        }
        else {
            // nil videoObject 
            [self showErrorMessage:@"Sorry, there was an error (videoObject nil)."];
        }
    }
    else {
        // nil picker object, show mail message instead
        //[self showErrorMessage:@"Sorry, this device cannot send text."];
        [self displayComposerSheetEmail:url];
    }
}

// The mail compose view controller delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    //[self performSegueWithIdentifier:@"statusSegue" sender:self];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void)displayComposerSheetEmail:(NSString *)url {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
        PFObject *videoObject = myApp->videoObject;
        if (videoObject) {
            
            NSString *subject = NSLocalizedString(@"Here's a video for you!", @"EmailSubject");
            [picker setSubject:subject];
            
            // Set up the recipients.
            /***
            NSString *workEmail = [videoObject objectForKey:@"receiverEmailWork"];
            NSArray *toRecipients = [NSArray arrayWithObjects:workEmail, nil];
            [picker setToRecipients:toRecipients];
            ***/
            
            // Fill out the email body text.
            NSString *body = NSLocalizedString(@"Here's a video for you, click here:\n", @"SMSPreamble");
            body = [body stringByAppendingFormat:@"%@",url];
            [picker setMessageBody:body isHTML:NO];
            
            // Present the mail composition interface.
            [self presentModalViewController:picker animated:YES];
        }
        else {
            // nil videoObject 
            [self showErrorMessage:@"Sorry, there was an error (videoObject nil)."];
        }
    }
    else {
        // nil picker object, show mail message instead
        [self showErrorMessage:@"Sorry, this device cannot send text or email."];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
    //[self performSegueWithIdentifier:@"statusSegue" sender:self];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
