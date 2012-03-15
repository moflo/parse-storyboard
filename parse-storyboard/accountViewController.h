//
//  accountViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface accountViewController : UIViewController {
    BOOL buttonMoved;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)doLoginButton:(id)sender;
- (BOOL) loginPreFlightCheck;

@end
