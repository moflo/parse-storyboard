//
//!  InAppPurchaseManager.m
//!  In-App Purchase singleton, manager of purchase and recording of subscriptions
//
//  Created by d. nye on 3/5/10.
//  Copyright 2010 Mobile Flow LLC. All rights reserved.
//

#import "MFAppDelegate.h"
#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

static InAppPurchaseManager *_sharedInAppManager = nil;

+ (InAppPurchaseManager *)sharedInAppManager
{
	@synchronized([InAppPurchaseManager class])
	{
		if (!_sharedInAppManager)
			[[self alloc] init];
		
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([InAppPurchaseManager class])
	{
		NSAssert(_sharedInAppManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInAppManager = [super alloc];
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

-(id) init
{
	storeDoneLoading = NO;
	return self;
}

- (void) dealloc
{
	//[productSubscription4Pack release];
	//[productSubscription1Pack release];
	//[productSubscription4Pack release];
	//[super dealloc];
}

- (BOOL) storeLoaded
{
	return storeDoneLoading;
}

- (BOOL)hasMadePurchases
{
	//! Check to see whether a user has already made a purchase, if so upate UI, etc.
	return 	[[NSUserDefaults standardUserDefaults] boolForKey:@"hasMadePurchases" ];

}

- (void)requestAppStoreProductData
{

// Defined in app delegate header file
//#define kProductSubscription8Pack @"VidPack8"
//#define kProductSubscription4Pack @"VidPack4"
//#define kProductSubscription1Pack @"VidPack1"
	
    NSSet *productIdentifiers = [NSSet setWithObjects: kProductSubscription8Pack, kProductSubscription4Pack, kProductSubscription1Pack, nil ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark In-App Product Accessor Methods

- (SKProduct *)getProductSub8Pack
{
	return productSubscription8Pack;
}

- (NSString *)getProductSub8PacklocalPrice
{
	return productSubscription8Pack.localizedPrice;
}
- (NSString *)getProductSub8PacklocalTitle
{
	return productSubscription8Pack.localizedTitle;
}

- (SKProduct *)getProductSub4Pack
{
	return productSubscription4Pack;
}

- (NSString *)getProductSub4PacklocalPrice
{
	return productSubscription4Pack.localizedPrice;
}
- (NSString *)getProductSub4PacklocalTitle
{
	return productSubscription4Pack.localizedTitle;
}

- (SKProduct *)getProductSub1Pack
{
	return productSubscription1Pack;
}

- (NSString *)getProductSub1PacklocalPrice
{
	return productSubscription1Pack.localizedPrice;
}
- (NSString *)getProductSub1PacklocalTitle
{
	return productSubscription1Pack.localizedTitle;
}


#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	for (SKProduct *inAppProduct in products)
	{		
		if ([inAppProduct.productIdentifier isEqualToString:kProductSubscription8Pack])
		{
			productSubscription8Pack = inAppProduct;
		}
		if ([inAppProduct.productIdentifier isEqualToString:kProductSubscription4Pack])
		{
			productSubscription4Pack = inAppProduct;
		}
		if ([inAppProduct.productIdentifier isEqualToString:kProductSubscription1Pack])
		{
			productSubscription1Pack = inAppProduct;
		}
	}
	
    // productSubscription4Pack = [products count] == 1 ? [[products objectAtIndex:0] retain] : nil;
	/***
    if (productSubscription4Pack)
    {
		SKProduct *testProduct = productSubscription4Pack;
		
        NSLog(@"Product title: %@" , testProduct.localizedTitle);
        NSLog(@"Product description: %@" , testProduct.localizedDescription);
        NSLog(@"Product price: %@" , testProduct.price);
        NSLog(@"Product id: %@" , testProduct.productIdentifier);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore OK" 
														message:[NSString stringWithFormat:@"title: %@ desc: %@ price: %@ id: %@",testProduct.localizedTitle,testProduct.localizedDescription,testProduct.localizedPrice,testProduct.productIdentifier]
													   delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
    }
	***/
	
	storeDoneLoading = YES;
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore Error" 
														message:invalidProductId
													   delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
		storeDoneLoading = NO;
    }
    
    // finally release the reqest we alloc/init’ed in requestproductSubscription4PackData
    //[productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseSub8Pack
{
    //SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductSubscription8Pack];
    SKPayment *payment = [SKPayment paymentWithProduct:productSubscription8Pack];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseSub4Pack
{
    //SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductSubscription4Pack];
    SKPayment *payment = [SKPayment paymentWithProduct:productSubscription4Pack];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseSub1Pack
{
    //SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductSubscription1Pack];
    SKPayment *payment = [SKPayment paymentWithProduct:productSubscription1Pack];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// Restore completed transactions
- (void) restoreCompletedTransactions
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kProductSubscription8Pack])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"productSubscription8PackReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductSubscription4Pack])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"productSubscription4PackReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductSubscription1Pack])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"productSubscription1PackReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasMadePurchases" ];
	[[NSUserDefaults standardUserDefaults] synchronize];


    int videoCount = 0;
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //! Update view with remaining video count
        videoCount = [[currentUser objectForKey:@"videoCount"] intValue];

        if ([productId isEqualToString:kProductSubscription8Pack])
        {
            //! Add 8 pack of product...
            videoCount += kProductSubscription8PackIncrement;
        }
        if ([productId isEqualToString:kProductSubscription4Pack])
        {
            //! Add 4 pack of product...
            videoCount += kProductSubscription4PackIncrement;
        }
        if ([productId isEqualToString:kProductSubscription1Pack])
        {
            //! Add 1 product...
            videoCount += kProductSubscription1PackIncrement;
        }

        [currentUser setObject:[NSNumber numberWithInt:videoCount] forKey:@"videoCount"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                return;
            }
            else {
                // There was an error saving the videoObject.
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                //[self showErrorMessage:errorString];
                NSLog(@"Error in saving purchase: %@", errorString);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore Error" 
                                                                message:errorString
                                                               delegate:self 
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];

            }
        }];            
    }
    else {
        NSLog(@"Error in saving purchase, object was nil (currentUser)");
    }

}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
		//! Store transaction receipt to user data
		if ([transaction transactionState] == SKPaymentTransactionStatePurchased) {
			//[[UserManager sharedUserManager] saveReceiptData:transaction.transactionReceipt];
		}
		
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
		//NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
		NSString *messageToBeShown = @"Please try again later.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Complete Your Purchase" message:messageToBeShown
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t do anything
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

		// send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:nil];
  }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
}

@end