//
//  restoreViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/22/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface restoreViewController : UIViewController <UIAlertViewDelegate> {
    BOOL buttonMoved;
}
@property (weak, nonatomic) IBOutlet UITextField *userEmailText;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)doResetButton:(id)sender;
- (BOOL) resetPreFlightCheck;

@end
