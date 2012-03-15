//
//  statusViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface statusViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    __strong NSArray *objectArray;
    NSDateFormatter *dateFormatter;
}
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *vidsRemainingText;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, atomic) NSArray *objectArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)doPurchaseButton:(id)sender;
- (IBAction)doLogoutButton:(id)sender;

@end
