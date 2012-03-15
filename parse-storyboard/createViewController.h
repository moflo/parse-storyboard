//
//  createViewController.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createViewController : UIViewController <UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate> 
@property (weak, nonatomic) IBOutlet UIView *popupTextEditor;
@property (weak, nonatomic) IBOutlet UITextView *popupTextView;
@property (weak, nonatomic) IBOutlet UITextField *coverText;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)doCaptureButton:(id)sender;
- (IBAction)doCoverText:(id)sender;
- (IBAction)doEditDoneButton:(id)sender;
- (IBAction)doAccountButton:(id)sender;
- (IBAction)doPreviewButton:(id)sender;

@end
