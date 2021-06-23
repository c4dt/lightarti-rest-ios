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
    let dict_dir: String
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
 * Makes a synchronous call to the arti library to fetch the given url with the indicated method. The arti backend will
 * set up a new circuit over tor and send the request over this circuit.
 * In case of an error in the arti library, an ArtiError is thrown.
 * REST errors are returned through the 'status' field of the ReturnStruct.
 */
public func callArti(method: ArtiMethods, url: String,
                     headers: [String: [String]] = [:],
                     body: Data = Data([])) throws -> ReturnStruct {
    let resourcePath = Bundle.main.resourcePath!
    let ar = ArtiRequest(method: "\(method)", url: url, headers: headers,
                         body: [UInt8](body), dict_dir: resourcePath + "/directory");
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

enum ArtiError: Error {
    case internalError(str: String)
}

public struct ReturnStruct {
    var status: UInt16
    var headers: String
    var body: [UInt8]
}

/**
 const char *error,
 uint16_t status,
 const char *headers,
 const char *body,
 
 const char *method,
 const char *url,
 const char *headers,
 const char *body,
 const char *artiDic1,
 const char *artiDic2,

 */

/**
 * Makes a synchronous call to the arti library to fetch the given url with the indicated method. The arti backend will
 * set up a new circuit over tor and send the request over this circuit.
 * In case of an error in the arti library, an ArtiError is thrown.
 * REST errors are returned through the 'status' field of the ReturnStruct.
 */
public func callArti(method: String, url: String) throws -> ReturnStruct {
    let resp = call_arti(method, url, "", "", "", "");
    let err = resp.error as NSString as String != "";
    if err != "" {
        throw ArtiError.internalError(err);
    }
    
    let ret = ReturnStruct(
        status: resp.status,
        headers: resp.headers,
        body: resp.body
        )
     
    return ret;
}
