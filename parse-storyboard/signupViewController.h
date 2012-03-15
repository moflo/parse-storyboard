//
//  signupViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface signupViewController : UIViewController {
    BOOL buttonMoved;
}
@property (weak, nonatomic) IBOutlet UILabel *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *bannerRuleImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *userEmailText;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *userPassword2Text;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)doSignupButton:(id)sender;
- (BOOL) signupPreFlightCheck;

@end
