# JJTwitterAutofollow

#### What is it?

A simple drop-in singleton that will prompt your users to automatically follow an array of twitter accounts.

#### How does it work?

-  Initialize and set an array of the accounts you would like your user to follow.
```
[[JJTwitterAutofollow sharedManager] setUsersToFollow:@[@"_jeffreyjackson", @"appstore", @"autolean"]];
```

-  Display an alert asking permission or incentivizing the user to allow the app to connect to the device's twitter accounts.  A positive response will automatically cycle through **ALL** of the device's twitter accounts, and have each follow **ALL** of the accounts specified in JJTwitterAutofollow's init.  If the app doesn't have permission to the twitter accounts, the user will be prompted for authorization.
```
[[JJTwitterAutofollow sharedManager] promptFromViewController:self];
```

#### Extras

-  Do you want to set your own custom title, message, OK button title, or cancel button title?  Set these before you prompt your users.
```
@property (nonatomic, strong) NSString *promptTitle;
@property (nonatomic, strong) NSString *promptMessage;
@property (nonatomic, strong) NSString *okButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;
```

-  Want to know when JJTwitterAutofollow is complete?  Just watch for the NSNotification.
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedFollowing:) name:JJTwitterAutofollowDidCompleteNotification object:nil];
```

#### Credits

Thanks to @nst for his work in [STTwitter](https://github.com/nst/STTwitter). 
