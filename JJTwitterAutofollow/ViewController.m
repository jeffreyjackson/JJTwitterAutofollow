//
//  ViewController.m
//  JJTwitterAutofollow
//
//  Created by Jeffrey Jackson on 7/16/15.
//  Copyright (c) 2015 AutoLean, Inc. All rights reserved.
//

#import "ViewController.h"
#import "JJTwitterAutofollow.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completedFollowing:) name:JJTwitterAutofollowDidCompleteNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[JJTwitterAutofollow sharedManager] promptFromViewController:self];
}

- (void)completedFollowing:(NSNotification *)notification {
    NSLog(@"Twitter Autofollow Complete");
}

@end
