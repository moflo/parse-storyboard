//
//  confirmViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface confirmViewController : UIViewController  {
    __strong PFFile *fileObject;             //!< local PFFile object contained uploaded data
}
@property (strong, atomic) PFFile *fileObject;
@property (weak, nonatomic) IBOutlet UILabel *confirmText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
- (IBAction)doSendButton:(id)sender;
- (IBAction)doCancelButton:(id)sender;
- (void) showErrorMessage:(NSString *)message;

@end
