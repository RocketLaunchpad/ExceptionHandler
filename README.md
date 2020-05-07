# ExceptionHandler

## Motivation

Objective-C supports two different kinds of errors: `NSError` and `NSException`. When interoperating with Swift, `NSError` maps to Swift's [error handling syntax][swift-error]. In Objective-C, a method with a signature like this:

```objc
- (nullable NSString *)performWithValue:(NSString *)value error:(NSError **)error
```

is equivalent to this in Swift:

```swift
func perform(withValue value: String) throws -> String
```

Swift uses `throws`, `try`, and `catch` keywords that are used in other languages in exception handling. However, Swift does not use the term _exception_ in relation to this feature. This is solely for error handling, and maps directly to the in-out `NSError` parameter used in Objective-C.

Objective-C also supports throwing `NSException` objects. This is done via the `@throw` keyword and is handled in a `@try` and `@catch` block. For example:

```objc
- (nullable NSString *)performWithValue:(NSString *)value
{
    @throw [NSException exceptionWithName:... reason:... userInfo:nil];
}

// ...

@try
{
    [obj performWithValue:@"foo"];
}
@catch (NSException *ex)
{
    NSLog(@"An error occurred");
}
```

This exception handling mechanism is not available in Swift. If an `NSException` is thrown, your app will crash. This is not an oversight &mdash; it is an intentional exclusion from Swift.

From Apple's [Exception Programming Topics][exception-pt]:

> The Cocoa frameworks are generally not exception-safe. The general pattern is that exceptions are reserved for programmer error only, and the program catching such an exception should quit soon afterwards.

From a [Stack Overflow post by an Apple engineer][so-answer]:

> When an exception is thrown by the frameworks, it indicates that the frameworks have detected an error state that is both not recoverable and for which the internal state is now undefined. Exceptions are not to be used in Cocoa for flow control, user input validation, data validity detection or to otherwise indicate recoverable errors. For that, you use `NSError` pattern.

By default in ARC is _not exception-safe_. It _does not end the lifetime of strong variables_ when their scopes are abnormally terminated by an exception. It _does not perform releases_ which would occur at the end of a full-expression if that full-expression throws an exception.

The standard Cocoa convention is that exceptions signal programmer error and are not intended to be recovered from. Making code exceptions-safe by default would impose severe runtime and code size penalties on code that typically does not actually care about exceptions safety. Therefore, ARC-generated code leaks by default on exceptions, which is just fine if the process is going to be immediately terminated anyway. ([Source][apple-forum])

## Exposing `NSException` handling to Swift

Given the caveats above, it's clearly not a good idea to handle Objective-C exceptions in Swift. However, if you understand and are willing to accept the associated risks, there exists a way to expose these exceptions in Swift. This library represents a way to do so.

```swift
import ExceptionHandler

do {
    try ObjcExceptionHandler.run {
        // call void Objective-C function that could throw an exception
        objcVoidFunctionThatCouldThrow()
    }

    let result = try ObjcExceptionHandler.result {
        // call Objective-C function that could throw an exception and return a value
        // result gets this return value if no exception is thrown
        return objcFunctionThatCouldThrow()
    }
}
catch {
    print("An error occurred: \(error)")
}
```

Again, this is not a recommended approach. At best, the called code will leak resources. At worst, the called code's module will be left in an inconsistent state. Use at your own risk.

[swift-error]: https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html
[exception-pt]: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Exceptions/Articles/ExceptionsAndCocoaFrameworks.html
[so-answer]: https://stackoverflow.com/a/4649224/511287
[apple-forum]: https://forums.developer.apple.com/thread/86184
