//
//  sendViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *recipientName;
- (IBAction)doConfirmButton:(id)sender;
- (void) showErrorMessage:(NSString *)message;
@end
