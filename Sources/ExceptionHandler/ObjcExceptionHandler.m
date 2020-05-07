//
//  ObjcExceptionHandler.m
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

#import "ObjcExceptionHandler.h"

#pragma mark - Errors

NSErrorDomain const ObjcExceptionErrorDomain = @"ObjcExceptionErrorDomain";

NSErrorUserInfoKey const ObjcExceptionCause = @"ObjcExceptionCause";

#pragma mark - Private Interface

@interface ObjcExceptionHandler ()

+ (NSError *)errorFromException:(NSException *)exception;

@end

#pragma mark - Implementation

@implementation ObjcExceptionHandler

+ (NSError *)errorFromException:(NSException *)exception
{
    return [NSError errorWithDomain:ObjcExceptionErrorDomain
                               code:ObjcExceptionErrorCodeExceptionOccurred
                           userInfo:@{
                               ObjcExceptionCause: exception,
                               NSLocalizedDescriptionKey: exception.reason
                           }];
}

+ (BOOL)run:(void (NS_NOESCAPE ^)(void))tryBlock error:(NSError **)error
{
    @try
    {
        tryBlock();
        return YES;
    }
    @catch (NSException *exception)
    {
        if (error)
        {
            *error = [self errorFromException:exception];
            return NO;
        }
    }
}

+ (nullable id)resultOf:(id (NS_NOESCAPE ^)(void))tryBlock error:(NSError **)error
{
    @try
    {
        return tryBlock();
    }
    @catch (NSException *exception)
    {
        if (error)
        {
            *error = [self errorFromException:exception];
        }
        return nil;
    }
}

@end
