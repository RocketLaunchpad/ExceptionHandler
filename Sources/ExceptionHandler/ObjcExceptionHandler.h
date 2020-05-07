//
//  ObjcExceptionHandler.h
//  ExceptionHandler
//
//  Copyright (c) 2020 Rocket Insights, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Errors

extern NSErrorDomain const ObjcExceptionErrorDomain;

typedef NS_ENUM(NSInteger, ObjcExceptionErrorCode)
{
    ObjcExceptionErrorCodeExceptionOccurred
};

extern NSErrorUserInfoKey const ObjcExceptionCause;

#pragma mark - Interface

@interface ObjcExceptionHandler : NSObject

/**
 Runs the specified block in a try/catch block. If an `NSException` is thrown, it is caught and converted to an `NSError` and returned via the `error` parameter.

 @returns `YES` if no exceptions are thrown, `NO` otherwise.
 */
+ (BOOL)run:(void (NS_NOESCAPE ^)(void))tryBlock error:(NSError **)error;

/**
 Runs the specified block in a try/catch block, returning its result if successful. If an `NSException` is thrown, it is caught and converted to an `NSError` and returned via the `error` parameter.

 @returns the result of the specified block, or `nil` if an exception was thrown.
 */
+ (nullable id)resultOf:(id (NS_NOESCAPE ^)(void))tryBlock error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
