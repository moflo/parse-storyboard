//
//!  InAppPurchaseManager.h
//!  In-App Purchase singleton, manager of purchase and recording of subscriptions
//
//  Created by d. nye on 3/5/10.
//  Copyright 2010 Mobile Flow LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *productSubscription8Pack, *productSubscription4Pack, *productSubscription1Pack;
    SKProductsRequest *productsRequest;
	BOOL storeDoneLoading;
}

+(InAppPurchaseManager *)sharedInAppManager;

- (void)requestAppStoreProductData;
- (void)loadStore;
- (BOOL)storeLoaded;
- (BOOL)canMakePurchases;
- (BOOL)hasMadePurchases;
- (void)purchaseSub8Pack;
- (void)purchaseSub4Pack;
- (void)purchaseSub1Pack;
- (void)restoreCompletedTransactions;
- (SKProduct *)getProductSub8Pack;
- (NSString *)getProductSub8PacklocalPrice;
- (NSString *)getProductSub8PacklocalTitle;
- (SKProduct *)getProductSub4Pack;
- (NSString *)getProductSub4PacklocalPrice;
- (NSString *)getProductSub4PacklocalTitle;
- (SKProduct *)getProductSub1Pack;
- (NSString *)getProductSub1PacklocalPrice;
- (NSString *)getProductSub1PacklocalTitle;

@end

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end