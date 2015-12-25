//
//  XBViewController.m
//  XBCacheRequest
//
//  Created by eugenenguyen on 03/06/2015.
//  Copyright (c) 2014 eugenenguyen. All rights reserved.
//

#import "XBViewController.h"
#import "XBCacheRequest.h"

@interface XBViewController ()

@end

@implementation XBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[XBCacheRequestManager sharedInstance] setHost:@"http://188.166.231.94/index.php"];
    XBCacheRequest *request = XBCacheRequest(@"http://188.166.231.94/index.php/invitation/8/image");
    [request setDataPost:[@{@"foo": @"bar",
                            @"veryfoor": @"bartoo"} mutableCopy]];
    [request setMethod:XBRequestMethodGET];
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error, id object) {
        NSLog(@"%@", object);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
