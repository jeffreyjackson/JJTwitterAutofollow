//
//  JJTwitterAutofollow.h
//  JJTwitterAutofollow
//
//  Created by Jeffrey Jackson on 7/16/15.
//  Copyright (c) 2015 AutoLean, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter.h>
#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface JJTwitterAutofollow : NSObject

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) __block NSMutableArray *accounts;
@property (nonatomic, strong) NSArray *usersToFollow;

@property (nonatomic, strong) NSString *promptTitle;
@property (nonatomic, strong) NSString *promptMessage;
@property (nonatomic, strong) NSString *okButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;

+ (JJTwitterAutofollow *)sharedManager;
- (void)promptFromViewController:(UIViewController *)viewController;

@end
