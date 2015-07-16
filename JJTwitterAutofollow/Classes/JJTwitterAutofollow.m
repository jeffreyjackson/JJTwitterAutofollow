//
//  JJTwitterAutofollow.m
//  JJTwitterAutofollow
//
//  Created by Jeffrey Jackson on 7/16/15.
//  Copyright (c) 2015 AutoLean, Inc. All rights reserved.
//

#import "JJTwitterAutofollow.h"

static JJTwitterAutofollow *_sharedManager = nil;

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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"AutoLean Connect" message:@"Follow us on Twitter and stay engaged on upcoming applications and feature releases.  We'd also love to hear from you about how much you're improving your processes!"  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"Follow on Twitter!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self authenticate];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:OK];
    [alert addAction:cancel];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
