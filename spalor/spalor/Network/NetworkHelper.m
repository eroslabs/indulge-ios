//
//  NetworkHelper.m
//  Thrill
//
//  Created by Manish on 02/06/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkHelper.h"
#import "Constants.h"
#import "NSData+NSData_AES256.h"
#import "AESCrypt.h"

@interface NetworkHelper()
@property(nonatomic, strong)NSOperationQueue *queueManager;
@end

@implementation NetworkHelper

+(NetworkHelper *)sharedInstance {
    static NetworkHelper *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
        
    });
    return _sharedClient;
}

const NSUInteger NUMBER_OF_CHARS = 9;
NSString *AESKey =@"ER0SLABSC01NDULG3";

NSString * APIRequestID()
{
    unichar characters[NUMBER_OF_CHARS];
    static char const possibleChars[] = "abcdefghijklmnopqrstuvwxyz0123456789";
    
    for( int index=0; index < NUMBER_OF_CHARS; ++index )
    {
        characters[ index ] = possibleChars[arc4random_uniform(sizeof(possibleChars)-1)];
    }
    
    return [ NSString stringWithCharacters:characters length:NUMBER_OF_CHARS ] ;
}


-(NSURLRequest *)formRequestwithemail:(NSString *)emailId andURLString:(NSString *)urlString{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString *token = APIRequestID();
    [request setValue:token forHTTPHeaderField:@"token"];
    [request setValue:emailId forHTTPHeaderField:@"email"];
    
    NSString *auth = [NSString stringWithFormat:@"%@%@",token,emailId];
    NSString *encryptedAuth = [AESCrypt encrypt:auth password:AESKey];

    DLog(@"AESCrypt %@ %@",encryptedAuth,[AESCrypt decrypt:encryptedAuth password:AESKey]);
    
    [request setValue:encryptedAuth forHTTPHeaderField:@"auth"];
    [request setValue:INDULGE_API_VERSION_STRING forHTTPHeaderField:@"version"];
    return request;
}



- (void)getArrayFromPutURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSDictionary *payloadDict = [sessionDict objectForKey:@"session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    
    NSString *stringData = [self prepareBody:dicParams];
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@?_request_id=%@&_api_version_id=%@",INDULGE_URL,url,APIRequestID(),INDULGE_API_VERSION];
    
    if (authToken.length>0) {
        [urlString appendString:[NSString stringWithFormat:@"&_auth_token=%@",authToken]];
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"PUT"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: data];

    if(!self.queueManager) {
        self.queueManager = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queueManager completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];

}


- (void)getArrayFromPostURL:(NSString *)url completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    //NSDictionary *payloadDict = [sessionDict objectForKey:@"session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@?_request_id=%@&_api_version_id=%@",INDULGE_URL,url,APIRequestID(),INDULGE_API_VERSION];
    
    
    DLog(@"authtoken %@",authToken);
    
    if (authToken.length>0) {
        [urlString appendString:[NSString stringWithFormat:@"&_auth_token=%@",authToken]];
    }

    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if(!self.queueManager) {
        self.queueManager = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queueManager completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];

}


- (void)getArrayFromPostURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    
    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSDictionary *payloadDict = [sessionDict objectForKey:@"session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    
    NSString *stringData = [self prepareBody:dicParams];
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@?_request_id=%@&_api_version_id=%@",INDULGE_URL,url,APIRequestID(),INDULGE_API_VERSION];
    
    DLog(@"authtoken %@",authToken);
    
    if (authToken.length>0) {
        [urlString appendString:[NSString stringWithFormat:@"&_auth_token=%@",authToken]];
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: data];
    
    if(!self.queueManager) {
        self.queueManager = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queueManager completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];

}

- (void)getArrayFromGetUrl:(NSString *)url withParameters:(NSDictionary *)parameters completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@?",INDULGE_URL,url];
    
    int index = 0;
    for (NSString *key in [parameters allKeys]) {
        if (index == 0) {
            [urlString appendString:[NSString stringWithFormat:@"%@=%@",key,parameters[key]]];

        }
        else{
            [urlString appendString:[NSString stringWithFormat:@"&%@=%@",key,parameters[key]]];

        }
        index++;
    }
    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue: @"application/json" forHTTPHeaderField:@"accept"];

    if(!self.queueManager) {
        self.queueManager = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queueManager completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];
    
}


- (void)getArrayFromGetUrl:(NSString *)url completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSDictionary *payloadDict = [sessionDict objectForKey:@"session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?_request_id=%@&_auth_token=%@%&_api_version_id=%@",INDULGE_URL,url,APIRequestID(),authToken,INDULGE_API_VERSION];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"GET"];

    
    if(!self.queueManager) {
        self.queueManager = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queueManager completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];

}

- (void)getArrayWithoutAppendingBaseFromGetUrl:(NSString *)url onQueue:(NSOperationQueue *)queue completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSDictionary *payloadDict = [sessionDict objectForKey:@"session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    NSString *urlString = url;
    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"GET"];
    
    
    if(!queue) {
        queue = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];
    
}




- (void)getArrayFromGetUrl:(NSString *)url onQueue:(NSOperationQueue *)queue completionHandler:(void (^)(id response, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSDictionary *payloadDict = [sessionDict objectForKey:@"session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?_request_id=%@&_auth_token=%@%&_api_version_id=%@",INDULGE_URL,url,APIRequestID(),authToken,INDULGE_API_VERSION];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    DLog(@"url string %@",urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"GET"];
    
    
    if(!queue) {
        queue = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,urlString,connectionError);
        
    }];
    
}


-(void)uploadFileWithPostURL:(NSString *)url withData:(NSData *)data ofType:(NSString *)type onQueue:(NSOperationQueue *)queue completionHandler:(void (^)(NSMutableArray *arrayResult, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@/%@?_request_id=%@&_auth_token=%@&_api_version_id=%@",INDULGE_URL,sessionDict[@"account_id"],url,APIRequestID(),authToken,INDULGE_API_VERSION];
    
    DLog(@"url %@",urlString);
    
    //    urlString = @"http://api.thrillapp.com/accounts/533e7c6011e2ac413a000e80/picture?_request_id=skzsylzz7t6fanoq20p6fvadb1j1h24h&_auth_token=6ab8cd70d81a0131aca322000a928618&_api_version_id=1.1";
    //
    //    urlString = @" http://ec2-54-254-56-201.ap-southeast-1.compute.amazonaws.com/picture?_request_id=szu3x614cp3ql9bm3drqsl861ea236g0&_auth_token=fdf9f980d8220131aca122000a928618&_api_version_id=1.1";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    if (!queue) {
        queue = [NSOperationQueue new];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,url,connectionError);
        
    }];
    
    
    return;
}

-(void)uploadFileWithPostURL:(NSString *)url withData:(NSData *)data ofType:(NSString *)type completionHandler:(void (^)(NSMutableArray *arrayResult, NSString *url, NSError *error))block {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA"];
    NSDictionary *sessionDict = tokenData[@"server_session"];
    NSString *authToken = [sessionDict objectForKey:@"auth_token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/accounts/%@/%@?_request_id=%@&_auth_token=%@&_api_version_id=%@",INDULGE_URL,sessionDict[@"account_id"],url,APIRequestID(),authToken,INDULGE_API_VERSION];
    
    DLog(@"url %@",urlString);
    
//    urlString = @"http://api.thrillapp.com/accounts/533e7c6011e2ac413a000e80/picture?_request_id=skzsylzz7t6fanoq20p6fvadb1j1h24h&_auth_token=6ab8cd70d81a0131aca322000a928618&_api_version_id=1.1";
//    
//    urlString = @" http://ec2-54-254-56-201.ap-southeast-1.compute.amazonaws.com/picture?_request_id=szu3x614cp3ql9bm3drqsl861ea236g0&_auth_token=fdf9f980d8220131aca122000a928618&_api_version_id=1.1";
    


    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:TIMEOUTINTERVAL];
    [request setHTTPMethod:@"POST"];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queueManager completionHandler:^(NSURLResponse *response,NSData *data,NSError *connectionError){
        block(data,url,connectionError);
        
    }];

    
    return;
}


- (NSString *)prepareBody:(NSDictionary *)dicParams {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicParams
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if(!jsonData) {
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
}


- (void)cancelAllPreviousOperations {
    if(self.queueManager) {
        [self.queueManager cancelAllOperations];
    }
    
}





@end
