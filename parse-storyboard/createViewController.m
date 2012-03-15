//
//  createViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "createViewController.h"
#import "Parse/Parse.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

@implementation createViewController
@synthesize popupTextEditor;
@synthesize popupTextView;
@synthesize coverText;
@synthesize accountButton;
@synthesize scrollView;
@synthesize contentView;
@synthesize coverImageView;
@synthesize captureButton;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [nextButton.layer setCornerRadius:8.0f];
    [nextButton.layer setMasksToBounds:YES];

    // Configure the scroll view
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 800);

}

- (void)viewDidUnload
{
    [self setAccountButton:nil];
    [self setCoverText:nil];
    [self setPopupTextEditor:nil];
    [self setPopupTextView:nil];
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setCoverImageView:nil];
    [self setCaptureButton:nil];
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
        //! Create placeholder video infomation
        [coverText setText:[videoObject objectForKey:@"coverText"]];

        NSString *imageFile =[videoObject objectForKey:@"coverImageName"];
        imageFile = [imageFile stringByAppendingString:DESIGN_THUMBNAIL_CONFIRMSCREEN_PREFIX];
        imageFile = [imageFile stringByAppendingString:@".png"];
        UIImage *frontImage = [UIImage imageNamed:imageFile];
        [coverImageView setImage:frontImage];

        //! TODO: find a way to set a video preview image
        MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
        UIImage *image = [UIImage imageWithData:myApp->imageData];
        if (image) {
            [self.captureButton setImage:image forState:UIControlStateNormal];
            [self.captureButton setImage:image forState:UIControlStateHighlighted];
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
#define kAlertSheetPhotoPicker 111
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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			if (actionSheet.tag == kAlertSheetPhotoPicker) 
			{
				// Launch photo picker
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                // Adding video request                
                picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                picker.videoMaximumDuration = MAXIMUM_VIDEO_DURATION;
                picker.videoQuality = UIImagePickerControllerQualityTypeLow;

				picker.delegate = self;
				picker.allowsEditing = YES;
				[self presentModalViewController:picker animated:YES];
			}
			break;
		case 1:
			if (actionSheet.tag == kAlertSheetPhotoPicker) 
			{
				// Launch photo picker
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
                picker.videoMaximumDuration = MAXIMUM_VIDEO_DURATION;
				picker.delegate = self;
				picker.allowsEditing = YES;
				[self presentModalViewController:picker animated:YES];
			}
			break;
		default:
			break;
	}
}

- (IBAction)doCaptureButton:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        //NSLog(@"doCaptureButton: available media types %@", mediaTypes);
        if ([mediaTypes containsObject:(NSString *) kUTTypeMovie] == YES) {
            // Video recording supported to give user the option
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Video" 
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Take Video",@"Library",nil];
            
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet setTag:kAlertSheetPhotoPicker];
            [actionSheet showInView:self.view];
        }
        else {
            // No video recording available, default to library selection
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        }
	}
	else {
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
		picker.delegate = self;
		picker.allowsEditing = YES;
		[self presentModalViewController:picker animated:YES];
	}

}

/***
- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo {

    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    myApp->imageData = UIImagePNGRepresentation(image);
    
    [picker dismissModalViewControllerAnimated:YES];

}
***/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
        myApp->moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
        NSURL *movieURL = [NSURL fileURLWithPath:myApp->moviePath];
        myApp->movieData = [NSData dataWithContentsOfURL:movieURL];

        // Hack instead of using AssetLibrary
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        UIImage *image = [player thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        myApp->imageData = UIImagePNGRepresentation(image);
        [player stop];

    }

    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
        UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        myApp->imageData = UIImagePNGRepresentation(image);
    }

    [picker dismissModalViewControllerAnimated:YES];
    
}


- (IBAction)doCoverText:(id)sender {
    
    coverText.inputAccessoryView = popupTextEditor;
    popupTextEditor.hidden = NO;
    popupTextView.text = coverText.text;
    [coverText resignFirstResponder];
    [popupTextView becomeFirstResponder];
}

- (IBAction)doEditDoneButton:(id)sender {
    
    [popupTextView resignFirstResponder];
    [coverText resignFirstResponder];
    popupTextEditor.hidden = YES;

    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    if (videoObject) {
        
        [coverText setText:popupTextView.text];        
        [videoObject setObject:popupTextView.text forKey:@"coverText"];
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

- (IBAction)doPreviewButton:(id)sender {
    
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    if (myApp->movieData ) {
        [self performSegueWithIdentifier:@"previewSegue" sender:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video" 
                                                        message:@"You need to select or create a video first. (Swipe down...)"
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert setTag:kAlertDismissOK];

    }

}

@end
