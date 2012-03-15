//
//  previewViewController.m
//  ParseStarterProject
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "previewViewController.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>

@implementation previewViewController
@synthesize animationView;
@synthesize imageView;
@synthesize imageViewBack;
@synthesize accountButton;
@synthesize nextButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFlipped = NO;

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
    // Do any additional setup after loading the view from its nib.
    
    [nextButton.layer setCornerRadius:8.0f];
    [nextButton.layer setMasksToBounds:YES];

    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doFlipAction:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft;	// default
    [animationView addGestureRecognizer:recognizer];
	
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doFlipAction:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [animationView addGestureRecognizer:recognizer];

}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setAccountButton:nil];
    [self setAnimationView:nil];
    [self setImageViewBack:nil];
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

- (void) viewWillAppear:(BOOL)animated  {
    
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    
    if (videoObject) {
        //! Update image with video infomation
        NSString *imageFile =[videoObject objectForKey:@"coverImageName"];
        imageFile = [imageFile stringByAppendingString:DESIGN_THUMBNAIL_PREVIEWSCREEN_PREFIX];
        imageFile = [imageFile stringByAppendingString:@".png"];
        UIImage *frontImage = [UIImage imageNamed:imageFile];
        [imageView setImage:frontImage];
        
        //! TODO: find a way to set a video preview image
        MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
        UIImage *image = [UIImage imageWithData:myApp->imageData];
        if (image) {
            [imageViewBack setImage:image];
        }
    }
        
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

#pragma mark UIAlertView Handling

#define	kAlertDismissOK 101
#define kAlertLoginUser 120
#define kAlertBuyMoreVids 121

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			if (alertView.tag == kAlertLoginUser) 
			{
                [self performSegueWithIdentifier:@"accountSegue" sender:nil];
			}
			if (alertView.tag == kAlertBuyMoreVids) 
			{
                [self performSegueWithIdentifier:@"storeSegue" sender:nil];
			}
			break;
		default:
			break;
	}
}

- (IBAction)doConfirmButton:(id)sender {
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
        // Check if user has enough credits
        int count = [[currentUser objectForKey:@"videoCount"] intValue];
#if TARGET_IPHONE_SIMULATOR
        count = 99;
#endif
        if (count > 0) {
            [self performSegueWithIdentifier:@"confirmSegue" sender:sender];
        }
        else {
            // Check whether user wants to logout or not
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops..." 
                                                            message:@"You need to buy more videos."
                                                           delegate:self 
                                                  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy More",nil];
            [alert show];
            [alert setTag:kAlertBuyMoreVids];
        }
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

- (IBAction) doFlipAction: (id)sender
{
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	//! Update priority based on selected segment index, update UIView
	if (isFlipped) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.animationView cache:YES];
		self.imageView.hidden = NO;
		self.imageViewBack.hidden = YES;
	}
	else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.animationView cache:YES];
		self.imageView.hidden = YES;
		self.imageViewBack.hidden = NO;
	}
    isFlipped = !isFlipped;
	
	[UIView commitAnimations];
}

@end

