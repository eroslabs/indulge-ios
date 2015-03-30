//
//  NetworkHelper.h
//  Thrill
//
//  Created by Manish on 02/06/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject
+ (NetworkHelper *)sharedInstance;

- (void)getArrayFromPostURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)( id response, NSString *url, NSError *error))block;
- (void)getArrayFromPostURL:(NSString *)url completionHandler:(void (^)(id response, NSString *url, NSError *error))block;
- (void)getArrayFromGetUrl:(NSString *)url completionHandler:(void (^)(id response, NSString *url, NSError *error))block;
- (void)getArrayFromGetUrl:(NSString *)url withParameters:(NSDictionary *)parameters completionHandler:(void (^)(id response, NSString *url, NSError *error))block;
- (void)getArrayFromPutURL:(NSString *)url parmeters:(NSDictionary *)dicParams completionHandler:(void (^)(id response, NSString *url, NSError *error))block;
- (void)getArrayFromGetUrl:(NSString *)url onQueue:(NSOperationQueue *)queue completionHandler:(void (^)(id response, NSString *url, NSError *error))block;
//-(void)uploadFileWithPostURL:(NSString *)url withParmeters:(NSDictionary *)dicParams mediaData:(NSDictionary *)fileDataDict  completionHandler:(void (^)(NSMutableArray *arrayResult, NSString *url, NSError *error))block loadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))loadBlock;
-(void)uploadFileWithPostURL:(NSString *)url withData:(NSData *)data ofType:(NSString *)type completionHandler:(void (^)(NSMutableArray *arrayResult, NSString *url, NSError *error))block;
-(void)uploadFileWithPostURL:(NSString *)url withData:(NSData *)data ofType:(NSString *)type onQueue:(NSOperationQueue *)queue completionHandler:(void (^)(NSMutableArray *arrayResult, NSString *url, NSError *error))block;
- (void)cancelAllPreviousOperations;
- (void)getArrayWithoutAppendingBaseFromGetUrl:(NSString *)url onQueue:(NSOperationQueue *)queue completionHandler:(void (^)(id response, NSString *url, NSError *error))block;
@end
