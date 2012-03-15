//
//  previewViewController.h
//  ParseStarterProject
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface previewViewController : UIViewController {
    BOOL isFlipped;
}

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBack;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)doConfirmButton:(id)sender;
- (IBAction)doAccountButton:(id)sender;
- (IBAction) doFlipAction: (id)sender;

@end
