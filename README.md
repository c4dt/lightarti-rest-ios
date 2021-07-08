# arti-ios

iOS library for REST requests using arti.
This uses the code from [arti-rest](https://github.com/c4dt/arti-rest).
As such it is important to notice:

- arti itself mentions it's not ready for prime-time. In their
  [README](https://gitlab.torproject.org/tpo/core/arti/-/blob/main/README.md), they write
  **you should probably not use Arti in production**
- the current code implements caching of the tor-directory listing to avoid having
  to download some megabytes of node descriptors every so often. Again, given the right
  circumstances, this can be effective and secure enough. Under other circumstances
  this is something you don't want to do.

If you want to use this for your project, be sure to contact us in this repo.
We'll be happy to discuss enhancements and limitations of our solution.

## Directory cache

This version comes with a mandatory cache of the tor directory data.
This means that the app itself will have to download this data and make
it available in a directory to the library.

For more information, see [Directory Cache](https://github.com/c4dt/arti-rest/blob/directory_scripts/tools/README.md)

There is a daily tor-directory update here:
[arti-directory](https://github.com/c4dt/arti-directory)

# API

The `arti-ios` library exposes one call:

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