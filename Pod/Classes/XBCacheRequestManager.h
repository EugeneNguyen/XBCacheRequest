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

typedef BOOL (^XBCacheRequestPreProcessor)(XBCacheRequest * request, NSString * result, BOOL fromCache, NSError * error);

@interface XBCacheRequestManager : NSObject
{
    
}

@property (nonatomic, retain) NSString *host;
@property (nonatomic, assign) BOOL enablePlusIgniter;
@property (nonatomic, copy) XBCacheRequestPreProcessor callback;

+ (XBCacheRequestManager *)sharedInstance;
- (XBCacheRequest *)requestWithPath:(NSString *)path;

@end