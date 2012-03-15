//
//  confirmViewController.m
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "confirmViewController.h"

@implementation confirmViewController
@synthesize fileObject;
@synthesize confirmText;
@synthesize imageView;
@synthesize messageText;
@synthesize activityIndicator;
@synthesize sendButton;
@synthesize progressView;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setConfirmText:nil];
    [self setImageView:nil];
    [self setMessageText:nil];
    [self setSendButton:nil];
    [self setProgressView:nil];
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

- (void) viewWillAppear:(BOOL)animated  {
    
    sendButton.hidden = NO;
    progressView.hidden = YES;
    messageText.hidden = NO;
    activityIndicator.hidden = YES;

    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    
    if (videoObject) {
        //! Update recipient lable with video infomation
        NSString *imageFile =[videoObject objectForKey:@"coverImageName"];
        imageFile = [imageFile stringByAppendingString:DESIGN_THUMBNAIL_CONFIRMSCREEN_PREFIX];
        imageFile = [imageFile stringByAppendingString:@".png"];
        UIImage *frontImage = [UIImage imageNamed:imageFile];
        [imageView setImage:frontImage];

        /***
        messageText.text = [videoObject objectForKey:@"coverText"];
        
        NSString *titleText = NSLocalizedString(@"Video To ", @"ConfirmText");
        NSString *firstName = [videoObject objectForKey:@"receiverFirstName"];
        NSString *lastName = [videoObject objectForKey:@"receiverLastName"];
        NSString *mobilePhone = [videoObject objectForKey:@"receiverMobilePhone"];

        titleText = [titleText stringByAppendingFormat:@"%@ %@, @ %@", firstName, lastName, mobilePhone ];
        
        confirmText.text = titleText;
         ***/
        
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

- (IBAction)doSendButton:(id)sender {
    MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
    PFObject *videoObject = myApp->videoObject;
    //NSData *imageData = myApp->imageData;
    NSData *movieData = myApp->movieData;
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        [self showErrorMessage:@"Need to register first!"];
        return;
    }
    
    if (videoObject) {
        // Sanity check for videoObject
        //self.fileObject = [PFFile fileWithName:@"testimage.png" data:imageData];
        self.fileObject = [PFFile fileWithName:@"testmovie.mov" data:movieData];
        
        sendButton.hidden = YES;
        messageText.hidden = YES;
        activityIndicator.hidden = NO;
        progressView.hidden = NO;
        progressView.progress = 0.35;
        
        NSLog(@"confirmViewController: save file object");
        [self.fileObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            progressView.progress = 0.75;
            if (!error) {
                // The gameScore saved successfully.
                MFAppDelegate *myApp = (MFAppDelegate *)[UIApplication sharedApplication].delegate;
                PFObject *videoObject = myApp->videoObject;
                if (videoObject) {
                    
                    if (self.fileObject) {
                        NSString *fileURL = [self.fileObject url];
                        NSLog(@"confirmViewController: doSend, fileURL:%@",fileURL);
                        
                        [videoObject setObject:self.fileObject forKey:@"videoPFFile"];
                        [videoObject setObject:@"CUSTOMID" forKey:@"videoID"];
                        [videoObject setObject:fileURL forKey:@"videoURL"];
                        [videoObject setObject:[NSNumber numberWithInt:100] forKey:@"videoMB"];
                        [videoObject setObject:[NSNumber numberWithBool:YES] forKey:@"videoUploaded"];
                                                
                        // Add restriction on video access
                        NSLog(@"confirmViewController: do restrict access");
                        //videoObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                        [videoObject setObject:[PFUser currentUser] forKey:@"userID"];

                        NSLog(@"confirmViewController: save video object");
                        [videoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            progressView.progress = 0.8;
                            if (!error) {
                                // Success, so now decrement the user's video count record
                                PFUser *currentUser = [PFUser currentUser];
                                if (currentUser) {
                                    int count = [[currentUser objectForKey:@"videoCount"] intValue];
                                    [currentUser setObject:[NSNumber numberWithInt:(count-1)] forKey:@"videoCount"];
                                    
                                    NSLog(@"confirmViewController: save user object");
                                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        progressView.progress = 1.0;
                                        if (!error) {
                                            // Success so transition to status view
                                            [self performSegueWithIdentifier:@"shareSegue" sender:sender];
                                            //[self doComposeButton:nil];
                                        }
                                        else {
                                            // There was an error saving the videoObject.
                                            NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                            NSLog(@"Error with currentUser save in background: %@",errorString);
                                            [self showErrorMessage:@"Sorry, there was an error.\n(user not found)"];
                                        }
                                    }];
                                }
                                else {
                                    // There was an error finding the currentUser
                                    NSLog(@"Error with nil currentUser in doSendButton!");
                                    [self showErrorMessage:@"Sorry, there was an error.\n(user nil)"];
                                }
                                
                            }
                            else {
                                // There was an error saving the videoObject.
                                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                NSLog(@"Error with videoObject save in background: %@",errorString);
                                [self showErrorMessage:@"Sorry, there was an error.\n(video not found)"];
                            }
                        }];            
                    }
                    else {
                        // There was an error finding the fileObject
                        NSLog(@"Error with nil fileObject in doSendButton!");
                        [self showErrorMessage:@"Sorry, there was an error.\n(file nil)"];
                    }
                }
            } else {
                // There was an error saving the PFFile.
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                NSLog(@"Error with PFFile save in background: %@",errorString);
                [self showErrorMessage:@"Sorry, there was an error.\n(file not found)"];
            }
        }];

    }
    else {
        // There was an error finding the videoObject
        NSLog(@"Error with nil videoObject in doSendButton!");
        [self showErrorMessage:@"Sorry, there was an error.\n(video nil)"];
    }
}

    



- (IBAction)doCancelButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
