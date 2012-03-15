//
//  homeViewController.m
//  ParseStarterProject
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "homeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation homeViewController
@synthesize nextButton;
@synthesize accountButton;
@synthesize selectedDesignName;
@synthesize scrollView;
@synthesize pageControlContainer;
@synthesize pageControl;
@synthesize pageOne;
@synthesize pageTwo;
@synthesize shadowView;

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
    // Do any additional setup after loading the view from its nib.
    
    self.selectedDesignName = @"love";

    [nextButton.layer setCornerRadius:8.0f];
    [nextButton.layer setMasksToBounds:YES];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * 1;
	frame.origin.y = 0;
	pageTwo.frame = frame;
    //[self buildIconViews];
    
    [pageControlContainer.layer setCornerRadius:8.0f];
    [pageControlContainer.layer setMasksToBounds:YES];

    [shadowView.layer setCornerRadius:4.0f];
    [shadowView.layer setMasksToBounds:YES];
    
    // Set up a timer to tear down the splash page after a few seconds
    splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    [myApp.window addSubview:splashView];
	[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(removeSplashScreen:) userInfo:nil repeats:NO];

}

- (void) removeSplashScreen:(NSTimer *)timer
{
    [splashView removeFromSuperview];
}

- (void)viewDidUnload
{
    accountButton = nil;
    accountButton = nil;
    accountButton = nil;
    [self setNextButton:nil];
    [self setScrollView:nil];
    [self setPageOne:nil];
    [self setPageTwo:nil];
    [self setPageControl:nil];
    [self setShadowView:nil];
    [self setPageControlContainer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    myApp->videoObject = nil;
    myApp->imageData = nil;
    myApp->movieData = nil;
    myApp->moviePath = nil;

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
    
    [self buildIconViews];
}

-(void) buildIconViews
{
    NSArray *iconNames = [NSArray arrayWithObjects:DESIGN_ICON_NAME_ORDER, nil];
    NSMutableArray *iconButtons = [[NSMutableArray alloc] initWithCapacity:9];

    int tag_count = 0;
    for (NSString *name in iconNames) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
		[button addTarget:self action:@selector(doSelectDesign:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageFile = [name stringByAppendingString:DESIGN_THUMBNAIL_DESIGNSCREEN_PREFIX];
        imageFile = [imageFile stringByAppendingString:@".png"];
        [button setImage:[UIImage imageNamed:imageFile] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageFile] forState:UIControlStateHighlighted];
        button.titleLabel.text = name;  // Hack
        button.tag = tag_count++;   // for highlight hack
        button.adjustsImageWhenHighlighted = YES;
        button.tintColor = [UIColor lightGrayColor];
		[iconButtons addObject:button];
		
	}
    
    // Build static matix (linear array) of icon positions and bounding circles
#define cpv(x,y) CGPointMake(x,y)
	int xl=55, xm=160, xr=265, yt=56, ym=175, yb=294;
	CGPoint verts[] = {
		cpv(xl,yt), cpv(xm,yt), cpv(xr,yt),
		cpv(xl,ym), cpv(xm,ym), cpv(xr,ym),
		cpv(xl,yb), cpv(xm,yb), cpv(xr,yb),
	};

    
    // Loop over all icon views & move to position as per the vert matrix
	int i=0, page=1;
	for (UIButton *button in iconButtons) {
		if (i<9) {
			if (page==1) {
				[pageOne addSubview:button];
			}
			else {
				[pageTwo addSubview:button];
			}
			//NSLog(@"view.tag=%d (%.2f,%.2f)",i,iconVerts[i].x,iconVerts[i].y);
			button.center = CGPointMake(verts[i].x,verts[i].y);
		}
		if (++i == 9) {
			i=0;	// Reset for 9 icons per page
			page++;
		}
	}

    [self doSelectDesign:[iconButtons objectAtIndex:0]];
}

#pragma mark UIAlertView Handling

#define	kAlertDismissOK 101
#define kAlertLoginUser 120

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			if (alertView.tag == kAlertLoginUser) 
			{
                [self performSegueWithIdentifier:@"accountSegue" sender:nil];
			}
			break;
		default:
			break;
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

- (IBAction)doSelectDesign:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *designTitle = button.titleLabel.text;
    self.selectedDesignName = designTitle;
    shadowView.center = button.center;
    if (button.tag <9) {
        [pageOne insertSubview:shadowView belowSubview:button];
    }
    else {
        [pageTwo insertSubview:shadowView belowSubview:button];        
    }
}

- (IBAction)doNextButton:(id)sender {
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
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

        if (!videoObject) {
            //! Create placeholder video infomation
            myApp->videoObject = [[PFObject alloc] initWithClassName:@"VidObject"];
            videoObject = myApp->videoObject;
            [videoObject setObject:@"101" forKey:@"designType"];
            [videoObject setObject:self.selectedDesignName forKey:@"coverImageName"];
            [videoObject setObject:@"Hello!" forKey:@"coverText"];
            [videoObject setObject:@"Johnny" forKey:@"receiverFirstName"];
            [videoObject setObject:@"Appleseed" forKey:@"receiverLastName"];
            [videoObject setObject:@"4085551212" forKey:@"receiverMobilePhone"];
            [videoObject setObject:@"johnny@testing.com" forKey:@"receiverEmailWork"];
            [videoObject setObject:@"CUSTOMID" forKey:@"videoID"];
            [videoObject setObject:@"URL" forKey:@"videoURL"];
            [videoObject setObject:[NSNumber numberWithInt:100] forKey:@"videoMB"];
            [videoObject setObject:[NSNumber numberWithBool:NO] forKey:@"videoUploaded"];
            NSLog(@"createViewController: new video created!");
            //[videoObject save];
            
#if TARGET_IPHONE_SIMULATOR
            myApp->moviePath = @"testmovie.mov";
            NSURL *movieURL = [[NSBundle mainBundle] URLForResource:@"testmovie" withExtension:@"mov"];
            myApp->movieData = [NSData dataWithContentsOfURL:movieURL];
            
            // Hack instead of using AssetLibrary
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
            UIImage *image = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            myApp->imageData = UIImagePNGRepresentation(image);
#endif
        }

        [self performSegueWithIdentifier:@"createSegue" sender:sender];
    }

}

#pragma mark UIPageControl handling

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page - 1];
    //[self loadScrollViewWithPage:page];
    //[self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

@end
