import arti_rest
import Foundation

public enum ArtiError: Error {
    case internalError(str: String)
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

struct ArtiResponse: Codable {
    let error: String
    let status: UInt16
    let headers: [String: [String]]
    let body: [UInt8]
}

/**
 * Makes a synchronous call to the arti library to fetch the given url with the indicated method. The arti backend will
 * set up a new circuit over tor and send the request over this circuit.
 * In case of an error in the arti library, an ArtiError is thrown.
 * REST errors are returned through the 'status' field of the ReturnStruct.
 */
public func callArti(method: String, url: String) throws -> ReturnStruct {
    let resourcePath = Bundle.main.resourcePath!
    let ar = ArtiRequest(method: method, url: url, headers: [:],
                         body: [], dict_dir: resourcePath + "/directory");
    let ar_str = String(data: try JSONEncoder().encode(ar), encoding: .utf8);
    let resp = call_arti(ar_str).takeRetainedValue() as NSString as String;

    let resp_data = resp.data(using: .utf8)!
    let aresp: ArtiResponse = try JSONDecoder().decode(ArtiResponse.self, from: resp_data)
    if aresp.error != "" {
        throw ArtiError.internalError(str: aresp.error);
    }
        
    let ret = ReturnStruct(
        status: aresp.status,
        headers: aresp.headers,
        body: Data(aresp.body)
        )

    return ret;
}
