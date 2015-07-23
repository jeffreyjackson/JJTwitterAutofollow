//
//  JJTwitterAutofollow.m
//  JJTwitterAutofollow
//
//  Created by Jeffrey Jackson on 7/16/15.
//  Copyright (c) 2015 AutoLean, Inc. All rights reserved.
//

#import "JJTwitterAutofollow.h"

static JJTwitterAutofollow *_sharedManager = nil;
NSString * const JJTwitterAutofollowDidCompleteNotification = @"JJTwitterAutofollowDidCompleteNotification";

@implementation JJTwitterAutofollow

#pragma mark - Singleton

+ (JJTwitterAutofollow *)sharedManager
{
    if (_sharedManager) {
        return _sharedManager;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:NULL] init];
    });
    
    [_sharedManager setPromptTitle:@"Connect"];
    [_sharedManager setPromptMessage:@"Follow us on Twitter and stay up to date on upcoming applications and feature releases!"];
    [_sharedManager setOkButtonTitle:@"Follow on Twitter!"];
    [_sharedManager setCancelButtonTitle:@"Cancel"];
    
    return _sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)init
{
    if (_sharedManager) {
        return _sharedManager;
    }
    
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Methods 

- (void)authenticate {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [accountStore requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if(granted == NO) return;
        
        self.accounts = [[accountStore accountsWithAccountType:twitterAccountType] mutableCopy];
        
        [self verifyNextAccount];
    }];
}

- (void)verifyNextAccount {
    if ([self.accounts count] != 0) {
        ACAccount *account = [self.accounts firstObject];
        [self.accounts removeObject:account];
        
        [self verifyAccount:account andFollow:self.usersToFollow complete:^(NSError *error) {
            [self verifyNextAccount];
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:JJTwitterAutofollowDidCompleteNotification object:nil];
    }
}

- (void)verifyAccount:(ACAccount *)account andFollow:(NSArray *)usersToFollow complete:(void(^)(NSError *error))block {
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account];
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        __block NSError *error;
        
        dispatch_group_t downloadGroup = dispatch_group_create();
 
        for (int i = 0; i < [usersToFollow count]; i++) {
            dispatch_group_enter(downloadGroup);
        }

        for (int i = 0; i < [usersToFollow count]; i++) {
            [self.twitter postFollow:usersToFollow[i] successBlock:^(NSDictionary *user)
            {
                dispatch_group_leave(downloadGroup);
            } errorBlock:^(NSError *error) {
                dispatch_group_leave(downloadGroup);
            }];
        }
        
        dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
            if (block) {
                block(error);
            }
        });
        
    } errorBlock:^(NSError *error) {
        if (block) block(error);
    }];
}

- (void)promptFromViewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_sharedManager.promptTitle
                                                                   message:_sharedManager.promptMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:_sharedManager.okButtonTitle
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
        [self authenticate];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:_sharedManager.cancelButtonTitle
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:OK];
    [alert addAction:cancel];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
