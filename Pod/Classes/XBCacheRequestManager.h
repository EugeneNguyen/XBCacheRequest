//
//  XBCacheRequestManager.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/17/15.
//
//

#import <Foundation/Foundation.h>

#define XBCacheRequest(X) [[XBCacheRequestManager sharedInstance] requestWithPath:X]

@class XBCacheRequest;

@interface XBCacheRequestManager : NSObject
{
    
}

@property (nonatomic, retain) NSString *host;

+ (XBCacheRequestManager *)sharedInstance;
- (XBCacheRequest *)requestWithPath:(NSString *)path;

@end
