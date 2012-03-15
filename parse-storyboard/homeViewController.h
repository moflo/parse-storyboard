//
//  homeViewController.h
//  ParseStarterProject
//
//  Created by Mobile Flow LLC on 11/21/11.
//  Copyright (c) 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeViewController : UIViewController {
    NSString *selectedDesignName;
    BOOL pageControlUsed;
    UIImageView *splashView;
}

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (strong, nonatomic) NSString *selectedDesignName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *pageControlContainer;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *pageOne;
@property (weak, nonatomic) IBOutlet UIView *pageTwo;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
- (IBAction)doAccountButton:(id)sender;
- (IBAction)doNextButton:(id)sender;
- (IBAction)doSelectDesign:(id)sender;
-(void) buildIconViews;
- (void) removeSplashScreen:(NSTimer *)timer;


@end
