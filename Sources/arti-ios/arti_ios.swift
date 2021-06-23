import arti_rest
import Foundation

public func getTLS(domain: String) -> String {
    return call_tls_get(domain).takeRetainedValue() as NSString as String;
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
    resp = call_arti(method, url, "", "", "", "").takeRetainedValue();
    if resp.error as NSString as String != "" {
        throw ArtiError.internalError(str: resp.error as NSString as String);
    }
    
    let ret = ReturnStruct(
        status: resp.status,
        headers: resp.headers,
        body: resp.body
        )
     
    return ret;
}
