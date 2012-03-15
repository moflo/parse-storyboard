//
//  MFAppDelegate.h
//  parse-storyboard
//
//  Created by Mobile Flow LLC on 3/14/12.
//  Copyright (c) 2012 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

// Parse.com application keys
#define PARSE_APPLICTION_ID @"PARSE_APPLICATION_ID"     
#define PARSE_CLIENT_KEY @"PARSE_CLIENT_KEY"        

//#import "TestFlight.h"                                  // Used for testing only
//#define NSLog TFLog                                     // Used for testing only

#define INITIAL_NUMBER_FREE_CREDITS 2                     // Initial number of videos included with app
#define kProductSubscription8Pack @"VidPack8"          // AppStore product id for 8 videos
#define kProductSubscription8PackIncrement 8            // Number of videos to add when making this purchase
#define kProductSubscription4Pack @"VidPack4"          // AppStore product id for 4 videos
#define kProductSubscription4PackIncrement 4
#define kProductSubscription1Pack @"VidPack1"          // AppStore product id for 1 videos
#define kProductSubscription1PackIncrement 1

#define MAXIMUM_VIDEO_DURATION 30.0                     // Max recording time

// Flag to indicate whether local or remote server is used
#define USE_LOCAL_SERVER 0                                      
#define LOCAL_SERVER_NAME @"iMac-8.local:3000"
#define GLOBAL_SERVER_NAME @"furious-winter-1870.heroku.com"    // Mobileflow server

// Order of the images shown on the cover page, listed by name, no spaces allowed!
#define DESIGN_ICON_NAME_ORDER @"icon1",@"icon2",@"icon3",@"icon4",@"icon5",@"icon6",@"icon7",@"icon8",@"icon9"

#define DESIGN_THUMBNAIL_DESIGNSCREEN_PREFIX @".70"
#define DESIGN_THUMBNAIL_CONFIRMSCREEN_PREFIX @".200"
#define DESIGN_THUMBNAIL_PREVIEWSCREEN_PREFIX @".375"


@interface MFAppDelegate : UIResponder <UIApplicationDelegate> {
    
@public __strong PFObject *videoObject;   //!< Current videoObject, created in createViewController
@public NSData *imageData;      //!< Image data for current video object
@public NSString *moviePath;    //!< Video data movie path
@public NSData *movieData;      //!< Video data for current video object
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) PFObject *videoObject;


@end
