//
//  shareViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/25/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface shareViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UILabel *shareURLText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)doOpenURLButton:(id)sender;
- (IBAction)doSendSMSButton:(id)sender;
- (IBAction)doSendEmailButton:(id)sender;
- (IBAction)doAccountButton:(id)sender;
- (IBAction)doHomeButton:(id)sender;
-(void)displayComposerSheet:(NSString *)url;
-(void)displayComposerSheetEmail:(NSString *)url;
- (void) showErrorMessage:(NSString *)message;
-(NSString *)videoSharingURL;
@end
