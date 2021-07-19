# Arti-ios Swift Package

This Swift package is an iOS library for REST requests using arti.
This uses the code from [arti-rest](https://github.com/c4dt/arti-rest).

> :warning: **Warning: arti-ios is not secure in all situations** Arti-android builds on top of [arti-rest]((https://github.com/c4dt/arti-rest), which modifies several core parts of `arti`. It therefore does not have the same security guarantees as arti or the stock Tor client would. Before integrating this library check the reliability considerations in the [arti-rest]((https://github.com/c4dt/arti-rest) repository to make sure that the security offered by this library is sufficient for your use case. In case of doubt, contact us in this repo. We'll be happy to discuss enhancements and limitations of our solution.

## Directory cache

This version comes with a mandatory cache of the Tor directory data.
This means that the app itself will have to download this data and make
it available in a directory to the library.

For more information, see [Directory Cache](https://github.com/c4dt/arti-rest/blob/directory_scripts/tools/README.md)

There is a daily tor-directory update here:
[arti-directory](https://github.com/c4dt/arti-directory)

# API

The `arti-ios` library exposes one call.
There is an example at [arti-ios-test](https://github.com/c4dt/arti-ios-test/blob/main/arti-ios-test/BackgroundCall.swift) that shows how
to use it.

```
/**
 Makes a synchronous call to the arti library to fetch the given url with the indicated method. 
 The arti backend will
 set up a new circuit over tor and send the request over this circuit.
 In case of an error in the arti library, an ArtiError is thrown.
 REST errors are returned through the 'status' field of the ReturnStruct.
 
 - Parameters:
   - method: one of the ARtiMethods
   - url: the destination of the request
   - headers: of the request
   - body: data to be sent along
   
 - Returns: a ReturnStruct with the result
 
 - Throws: `ArtiError` in case something within the arti-library produced an error
 */
public func callArti(method: ArtiMethods, url: String,
                     headers: [String: [String]] = [:],
                     body: Data = Data([])) throws -> ReturnStruct
```

The `ReturnStruct` has the following definition:

```
public struct ReturnStruct {
    public var status: UInt16
    public var headers: [String: [String]]
    public var body: Data
}
```

Any REST-request error returns successfully, but the `status` field will be set to an error-code.
