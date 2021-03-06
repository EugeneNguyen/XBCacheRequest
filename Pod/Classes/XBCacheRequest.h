//
//  XBCacheRequest.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "AFNetworking.h"
#import "XBCacheRequestManager.h"
#import "MBProgressHUD.h"

@class XBCacheRequest;
typedef enum : NSUInteger {
    XBCacheRequestTypePlain,
    XBCacheRequestTypeJSON,
    XBCacheRequestTypeXML,
} XBCacherequestResponseType;

#define XBRequestMethodGET @"GET"
#define XBRequestMethodPOST @"POST"
#define XBRequestMethodPUT @"PUT"
#define XBRequestMethodDELETE @"DELETE"

typedef void (^XBPostRequestCallback)(XBCacheRequest * request, NSString * result, BOOL fromCache, NSError * error, id object);
typedef void (^AFNetworkFailed)(NSURLSessionDataTask *task, NSError *error);
typedef void (^AFNetworkSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void (^AFNetworkBuildBody)(id <AFMultipartFormData> formData);

@protocol XBCacheRequestDelegate <NSObject>

@optional

- (void)requestFinished:(XBCacheRequest *)request;
- (void)requestFailed:(XBCacheRequest *)request;
- (void)requestFinishedWithString:(NSString *)result;
- (void)request:(XBCacheRequest *)request finishedWithString:(NSString *)result;

@end

@interface XBCacheRequest : AFHTTPRequestSerializer
{
    XBPostRequestCallback callback;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableDictionary *dataPost;
@property (nonatomic, assign) id <XBCacheRequestDelegate> cacheDelegate;
@property (nonatomic, assign) BOOL disableCache;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) XBCacherequestResponseType responseType;
@property (nonatomic, assign) BOOL disableIndicator;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) NSMutableDictionary *files;
@property (nonatomic, retain) AFHTTPRequestSerializer *request_;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, retain) NSError *error;

- (void)addFileWithURL:(NSURL *)url key:(NSString *)key;
- (void)addFileWithData:(NSData *)data key:(NSString *)key fileName:(NSString *)filename mimeType:(NSString *)mimeType;

+ (XBCacheRequest *)requestWithURL:(NSURL *)url;

- (void)setCallback:(XBPostRequestCallback)_callback;
- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback;

+ (void)clearCache;

@end
