//
//  storeViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface storeViewController : UIViewController {
    NSTimer *storeUpdateTimer;								//!< Timer to check the status of the store

}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *buy8Button;
@property (weak, nonatomic) IBOutlet UIButton *buy4Button;
@property (weak, nonatomic) IBOutlet UIButton *buy1Button;
- (IBAction)doBuy8Button:(id)sender;
- (IBAction)doBuy4Button:(id)sender;
- (IBAction)doBuy1Button:(id)sender;
- (IBAction)doCancelButton:(id)sender;
-(void)noticePurchaseSuccess:(NSNotification *)notification;
- (void) noticePurchaseFailure:(NSNotification *)notification;
- (void) checkStoreLoaded:(NSTimer *)timer;
- (void) showStoreItems;

@end
