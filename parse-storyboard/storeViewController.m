//
//  storeViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "storeViewController.h"
#import "InAppPurchaseManager.h"

@implementation storeViewController
@synthesize activityIndicator;
@synthesize buy8Button;
@synthesize buy4Button;
@synthesize buy1Button;

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
    
    [[InAppPurchaseManager sharedInAppManager] loadStore];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticePurchaseSuccess:) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticePurchaseFailure:) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated {
    self.activityIndicator.hidden = NO;
    [self checkStoreLoaded:nil];
}

#pragma mark InAppPurchaseManager Methods

- (void) checkStoreLoaded:(NSTimer *)timer {
	//! Check to see if storeLoaded, if not refire timer...
	if ([[InAppPurchaseManager sharedInAppManager] storeLoaded])
	{
        self.activityIndicator.hidden = YES;
		storeUpdateTimer = nil;
		[self showStoreItems];		// Populate the UI with localized store information
	}
	else
	{
		storeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkStoreLoaded:) userInfo:nil repeats:NO];
		
	}
}

- (void) showStoreItems {
	//! Update the buttons & labels with text back from the store

	NSString *itemTitle, *itemPricing, *buttonTitle;
	
	//! Update  product UI information...
	itemPricing = [[InAppPurchaseManager sharedInAppManager] getProductSub8PacklocalPrice];
	itemTitle = [[InAppPurchaseManager sharedInAppManager] getProductSub8PacklocalTitle];
	buttonTitle = [NSString stringWithFormat:@"%@ @ %@",itemTitle,itemPricing];
	[self.buy8Button setTitle:buttonTitle forState:UIControlStateNormal];
	[self.buy8Button setTitle:buttonTitle forState:UIControlStateSelected];

	itemPricing = [[InAppPurchaseManager sharedInAppManager] getProductSub4PacklocalPrice];
	itemTitle = [[InAppPurchaseManager sharedInAppManager] getProductSub4PacklocalTitle];
	buttonTitle = [NSString stringWithFormat:@"%@ @ %@",itemTitle,itemPricing];
	[self.buy4Button setTitle:buttonTitle forState:UIControlStateNormal];
	[self.buy4Button setTitle:buttonTitle forState:UIControlStateSelected];

    itemPricing = [[InAppPurchaseManager sharedInAppManager] getProductSub1PacklocalPrice];
	itemTitle = [[InAppPurchaseManager sharedInAppManager] getProductSub1PacklocalTitle];
	buttonTitle = [NSString stringWithFormat:@"%@ @ %@",itemTitle,itemPricing];
	[self.buy1Button setTitle:buttonTitle forState:UIControlStateNormal];
	[self.buy1Button setTitle:buttonTitle forState:UIControlStateSelected];

    self.activityIndicator.hidden = YES;
    

}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setBuy1Button:nil];
    [self setBuy4Button:nil];
    [self setBuy8Button:nil];
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

- (void) showErrorMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" 
                                                    message:message
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert setTag:kAlertDismissOK];
    
}

- (IBAction)doBuy8Button:(id)sender {
    self.activityIndicator.hidden = NO;
    [[InAppPurchaseManager sharedInAppManager] purchaseSub8Pack];
}

- (IBAction)doBuy4Button:(id)sender {
    self.activityIndicator.hidden = NO;
    [[InAppPurchaseManager sharedInAppManager] purchaseSub4Pack];
}

- (IBAction)doBuy1Button:(id)sender {
    self.activityIndicator.hidden = NO;
    [[InAppPurchaseManager sharedInAppManager] purchaseSub1Pack];
}

- (IBAction)doCancelButton:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) noticePurchaseSuccess:(NSNotification *)notification {    

    [[self navigationController] popViewControllerAnimated:YES];
        
}

- (void) noticePurchaseFailure:(NSNotification *)notification {
    [self showErrorMessage:@"Error, purchased failed. Try again later."];    
}

@end
