//
//  XBViewController.m
//  XBCacheRequest
//
//  Created by eugenenguyen on 03/06/2015.
//  Copyright (c) 2014 eugenenguyen. All rights reserved.
//

#import "XBViewController.h"
#import <XBCacheRequest.h>

@interface XBViewController ()

@end

@implementation XBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[XBCacheRequestManager sharedInstance] setHost:@"http://libre.com.vn"];
    XBCacheRequest *request = XBCacheRequest(@"http://123.com/abc");
    [request setDataPost:[@{@"foo": @"bar",
                            @"veryfoor": @"bartoo"} mutableCopy]];
    [request startAsynchronousWithCallback:^(XBCacheRequest *request, NSString *result, BOOL fromCache, NSError *error) {
        if (error)
        {
            // handle error
        }
        else
        {
            // handle response
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
