/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Retrieves product information from the App Store using SKRequestDelegate,
         SKProductsRequestDelegate,SKProductsResponse, and SKProductsRequest.
         Notifies its observer with a list of products available for sale along with
         a list of invalid product identifiers. Logs an error message if the product 
         request failed.
 */


#import "StoreManager.h"

NSString * const IAPProductRequestNotification = @"IAPProductRequestNotification";

@interface StoreManager()<SKRequestDelegate, SKProductsRequestDelegate>
@end


@implementation StoreManager

+ (StoreManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static StoreManager * storeManagerSharedInstance;
    
    dispatch_once(&onceToken, ^{
        storeManagerSharedInstance = [[StoreManager alloc] init];
    });
    return storeManagerSharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _availableProducts = [[NSMutableArray alloc] initWithCapacity:0];
        _invalidProductIds = [[NSMutableArray alloc] initWithCapacity:0];
        _productRequestResponse = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


#pragma mark Request information

// 从APP STORE 获取有关产品的信息
-(void)fetchProductInformationForIds:(NSArray *)productIds
{
    // Create a product request object and initialize it with our product identifiers
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIds]];
    request.delegate = self;
    
    // Send the request to the App Store
    [request start];
}


#pragma mark - SKProductsRequestDelegate

// 获取有关产品信息的 请求结果
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [SVProgressHUD dismiss];
    self.status = IAPProductRequestResponse;
    if ((response.products).count > 0)//获取到产品信息
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPProductRequestNotification object:self userInfo:@{@"products":response.products}];
    }else{
        [SVProgressHUD showErrorWithStatus:NoKnowError];
    }
}


#pragma mark SKRequestDelegate method

// Called when the product request failed.
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    // Prints the cause of the product request failure
    NSLog(@"Product Request Status: %@",error.localizedDescription);
}


#pragma mark Helper method

// Return the product's title matching a given product identifier
-(NSString *)titleMatchingProductIdentifier:(NSString *)identifier
{
    NSString *productTitle = nil;
    // Iterate through availableProducts to find the product whose productIdentifier
    // property matches identifier, return its localized title when found
    for (SKProduct *product in self.availableProducts)
    {
        if ([product.productIdentifier isEqualToString:identifier])
        {
            productTitle = product.localizedTitle;
        }
    }
    return productTitle;
}

@end
