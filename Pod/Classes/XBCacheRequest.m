//
//  XBCacheRequest.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "XBCacheRequest.h"
#import "XBM_storageRequest.h"
#import "JSONKit.h"
#import "NSObject+deepCopy.h"

@implementation XBCacheRequest
@synthesize dataPost = _dataPost, cacheDelegate, disableCache, url;
@synthesize isRunning;
@synthesize responseType;
@synthesize disableIndicator;
@synthesize hud;
@synthesize files;
@synthesize request_;
@synthesize method;

+ (XBCacheRequest *)requestWithURL:(NSURL *)url
{
    XBCacheRequest *request = [[XBCacheRequest alloc] init];
    request.url = [url absoluteString];
    request.responseType = XBCacheRequestTypeJSON;
    request.files = [@{} mutableCopy];
    request.dataPost = [@{} mutableCopy];
    request.method = XBRequestMethodPOST;
    return request;
    return nil;
}

- (void)addFileWithURL:(NSURL *)_url key:(NSString *)key
{
    files[key] = _url;
}

- (void)addFileWithData:(NSData *)data key:(NSString *)key fileName:(NSString *)filename mimeType:(NSString *)mimeType
{
    files[key] = @{@"data": data,
                   @"filename": filename,
                   @"mimetype": mimeType};
}

- (void)setCallback:(XBPostRequestCallback)_callback
{
    callback = _callback;
}

- (void)startAsynchronousWithCallback:(XBPostRequestCallback)_callback
{
    [self setCallback:_callback];
    
    // get cache
    if (!disableCache)
    {
        XBM_storageRequest *cache = [XBM_storageRequest getCache:self.url postData:_dataPost];
        if (cache)
        {
            if ([XBCacheRequestManager sharedInstance].callback)
            {
                XBCacheRequestPreProcessor preprocessor = [XBCacheRequestManager sharedInstance].callback;
                id object = nil;
                switch (responseType) {
                    case XBCacheRequestTypeXML:
                        
                        break;
                    case XBCacheRequestTypeJSON:
                        object = [cache.response mutableObjectFromJSONString];
                        break;
                        
                    default:
                        break;
                }
                if (preprocessor(self, cache.response, YES, nil, object))
                {
                    if (callback) callback(self, cache.response, YES, nil, object);
                }
            }
            if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinishedWithString:)])
            {
                [cacheDelegate requestFinishedWithString:cache.response];
            }
            if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(request:finishedWithString:)])
            {
                [cacheDelegate request:self finishedWithString:cache.response];
            }
        }
    }
    
    // define failed block
    AFNetworkFailed failed = ^void(NSURLSessionDataTask *task, NSError *error) {
        if (!disableIndicator) [XBCacheRequestManager hideIndicator];
        if (hud) [hud hide:YES];
        isRunning = NO;
        //        _responseString = operation.responseString;
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFailed:)])
        {
            [cacheDelegate requestFailed:self];
        }
        
        if ([XBCacheRequestManager sharedInstance].callback)
        {
            XBCacheRequestPreProcessor preprocessor = [XBCacheRequestManager sharedInstance].callback;
            if (preprocessor(self, nil, NO, error, nil))
            {
                if (callback) callback(self, nil, NO, error, nil);
            }
        }
        else
        {
            if (callback) callback(self, nil, NO, error, nil);
        }
    };
    
    // define success block
    AFNetworkSuccess success = ^void(NSURLSessionDataTask *task, id responseObject) {
        if (!disableIndicator) [XBCacheRequestManager hideIndicator];
        if (hud) [hud hide:YES];
        
        isRunning = NO;
        if (cacheDelegate && [cacheDelegate respondsToSelector:@selector(requestFinished:)])
        {
            [cacheDelegate requestFinished:self];
        }
        
        if (responseObject)
        {
            responseObject = [responseObject deepMutableCopy];
            if ([responseObject isKindOfClass:[NSString class]])
            {
                [XBM_storageRequest addCache:url postData:_dataPost response:responseObject];
            }
            else if ([responseObject JSONString])
            {
                [XBM_storageRequest addCache:url postData:_dataPost response:[responseObject JSONString]];
            }
        }
        
        if ([XBCacheRequestManager sharedInstance].callback)
        {
            XBCacheRequestPreProcessor preprocessor = [XBCacheRequestManager sharedInstance].callback;
            if (preprocessor(self, nil, NO, nil, responseObject))
            {
                if (callback) callback(self, nil, NO, nil, responseObject);
            }
        }
        else
        {
            if (callback) callback(self, nil, NO, nil, responseObject);
        }
    };
    
    // define build body block
    AFNetworkBuildBody buildBody = ^void(id<AFMultipartFormData> formData) {
        for (NSString *key in [self.files allKeys])
        {
            id item = self.files[key];
            if ([item isKindOfClass:[NSDictionary class]])
            {
                [formData appendPartWithFileData:item[@"data"] name:key fileName:item[@"filename"] mimeType:item[@"mimetype"]];
            }
            else if ([item isKindOfClass:[NSURL class]])
            {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:item] name:key error:nil];
            }
        }
    };
    
    isRunning = YES;
    if (!disableIndicator) [XBCacheRequestManager showIndicator];
    if ([method isEqualToString:XBRequestMethodPOST])
    {
        [[AFHTTPSessionManager manager] POST:self.url parameters:_dataPost constructingBodyWithBlock:buildBody progress:nil success:success failure:failed];
    }
    else if ([method isEqualToString:XBRequestMethodGET])
    {
        [[AFHTTPSessionManager manager] GET:self.url parameters:_dataPost progress:nil success:success failure:failed];
    }
    else if ([method isEqualToString:XBRequestMethodPUT])
    {
        [[AFHTTPSessionManager manager] PUT:self.url parameters:_dataPost success:success failure:failed];
    }
    else if ([method isEqualToString:XBRequestMethodDELETE])
    {
        [[AFHTTPSessionManager manager] DELETE:self.url parameters:_dataPost success:success failure:failed];
    }
    //    switch (responseType) {
    //        case XBCacheRequestTypeJSON:
    //            [request_ setResponseSerializer:[AFJSONResponseSerializer serializer]];
    //            break;
    //            
    //        case XBCacheRequestTypeXML:
    //            [request_ setResponseSerializer:[AFXMLParserResponseSerializer serializer]];
    //            break;
    //            
    //        default:
    //            [request_ setResponseSerializer:[AFCompoundResponseSerializer serializer]];
    //            break;
    //    }
    //    [request_ setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
    //        
    //    }];
    //    [request_ setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    //        
    //    }];
    //    request_.responseSerializer.acceptableContentTypes = [request_.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/json", @"text/javascript", @"application/json", @"text/html"]];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        disableCache = NO;
    }
    return self;
}

+ (void)clearCache
{
    [XBM_storageRequest clear];
}

@end
