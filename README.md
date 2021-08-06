# Lightarti-rest-ios Swift Package

This Swift package is an iOS library for REST requests using arti.
This uses the code from [lightarti-rest](https://github.com/c4dt/lightarti-rest).

> :warning: **Warning: lightarti-rest-ios is not secure in all situations** Arti-android builds on top of [lightarti-rest]((https://github.com/c4dt/lightarti-rest), which modifies several core parts of `arti`. It therefore does not have the same security guarantees as arti or the stock Tor client would. Before integrating this library check the reliability considerations in the [lightarti-rest]((https://github.com/c4dt/lightarti-rest) repository to make sure that the security offered by this library is sufficient for your use case. In case of doubt, contact us in this repo. We'll be happy to discuss enhancements and limitations of our solution.

## Directory cache

This version comes with a mandatory cache of the Tor directory data.
This means that the app itself will have to download this data and make
it available in a directory to the library.

For more information, see [Directory Cache](https://github.com/c4dt/lightarti-rest/blob/main/tools/README.md)

There is a daily tor-directory update here:
[lightarti-directory](https://github.com/c4dt/lightarti-directory)

# API

The `lightarti-rest-ios` library exposes one call.
There is an example at [lightarti-rest-ios-test](https://github.com/c4dt/lightarti-rest-ios-test/blob/main/lightarti-rest-ios-test/BackgroundCall.swift) that shows how
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

# Release a new version

To release a new version, please use the provided `release.sh` script. 
It takes no arguments and does the following:
- updates `Package.swift` with the latest xcframework from lightarti-rest
- calculates the appropriate new tag
  - at least the same version as lightarti-rest
  - else increase the patch or release
- sets the tag

You'll have to do the `git push --tags` on your own.
