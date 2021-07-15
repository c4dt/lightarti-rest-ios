import arti_rest
import Foundation

public enum ArtiError: Error {
    case internalError(str: String, context: String?)
}

public struct ReturnStruct {
    public var status: UInt16
    // TODO: this should be [String: [Data]], but then it's difficult to use...
    public var headers: [String: [String]]
    public var body: Data
}

struct ArtiRequest: Codable {
    let method: String
    let url: String
    let headers: [String:[String]]
    let body: [UInt8]
    let cache_dir: String
}

struct ArtiReturn: Codable {
    let error: ArtiErr?
    let response: ArtiResponse?
}

struct ArtiResponse: Codable {
    let status: UInt16
    let headers: [String: [String]]
    let body: [UInt8]
}

struct ArtiErr: Codable {
    let error_string: String
    let error_context: String?
}

public enum ArtiMethods {
    case GET
    case POST
    case PUT
    case DELETE
    case UPDATE
}

/**
 Makes a synchronous call to the arti library to fetch the given url with the indicated method.
 The arti backend will
 set up a new circuit over tor and send the request over this circuit.
 In case of an error in the arti library, an ArtiError is thrown.
 REST errors are returned through the 'status' field of the ReturnStruct.

 - Parameters:
   - dict_dir:
   - method: one of the ARtiMethods
   - url: the destination of the request
   - headers: of the request
   - body: data to be sent along

 - Returns: a ReturnStruct with the result

 - Throws: `ArtiError` in case something within the arti-library produced an error
 */
public func callArti(dict_dir: String,
                     method: ArtiMethods, url: String,
                     headers: [String: [String]] = [:],
                     body: Data = Data([])) throws -> ReturnStruct {
    let ar = ArtiRequest(method: "\(method)", url: url, headers: headers,
                         body: [UInt8](body), cache_dir: dict_dir);
    let ar_str = String(data: try JSONEncoder().encode(ar), encoding: .utf8);
    let ret_json = call_arti(ar_str).takeRetainedValue() as NSString as String;

    let ret_data = ret_json.data(using: .utf8)!
    let ret: ArtiReturn = try JSONDecoder().decode(ArtiReturn.self, from: ret_data)
    if let err = ret.error {
        throw ArtiError.internalError(str: err.error_string, context: err.error_context);
    }
        
    if let response = ret.response {
        return ReturnStruct(
            status: response.status,
            headers: response.headers,
            body: Data(response.body)
            )
    }
    
    throw ArtiError.internalError(str: "Neither error nor response", context: nil)
}
