import lightarti_rest
import Foundation

public enum ArtiError: Error {
    case convertRequest
    case createClient(String)
    case send(String)
}

public struct Response {
    public var status: UInt16;
    public var headers: [String: [Data]];
    public var body: Data;
}

public class Client {
    private var client: Int;

    /**
     - Parameters:
     - dict_dir: directory containing the pre-downloaded consensus

     - Throws: `ArtiError` when failing to setup client
     */
    public init(dict_dir: String) throws {
        let client_res = client_new(dict_dir as NSString);
        guard client_res.is_ok else {
            throw ArtiError.createClient(client_res.value.err!.takeUnretainedValue() as String);
        }
        client = client_res.value.ok;
    }

    deinit {
        client_free(client)
    }

    /**
     Makes a synchronous call to the arti library to fetch the given url with the indicated method.
     The arti backend will set up a new circuit over tor and send the request over this circuit.
     In case of an error in the arti library, an ArtiError is thrown.

     - Parameters:
     - request: the request to execute

     - Returns: the result of the request

     - Throws: `ArtiError` when failing to send the request or receive the response
     */
    public func send (request: URLRequest) throws -> Response {
        guard let request = convRequest(request: request) else {
            throw ArtiError.convertRequest
        }

        let response_ret = client_send(client, request);
        guard response_ret.is_ok else {
            throw ArtiError.send(response_ret.value.err!.takeUnretainedValue() as String);
        }

        return convResponse(response: response_ret.value.ok)
    }
}

func convRequestMethod(methodRaw: String?) -> lightarti_rest.Method? {
    switch methodRaw {
        case "GET":
            return lightarti_rest.Get
        default:
            return nil
    }
}

func convRequest(request: URLRequest) -> Request? {
    guard let method = convRequestMethod(methodRaw: request.httpMethod),
          let url = request.url else {
        return nil
    }
    let headers = request.allHTTPHeaderFields ?? [:];
    let body = request.httpBody ?? Data.init();

    return Request.init(
        method: method,
        url: Unmanaged.passUnretained(url as CFURL),
        headers: Unmanaged.passUnretained(headers as CFDictionary),
        body: Unmanaged.passUnretained(body as CFData)
    )
}

func convResponse(response: lightarti_rest.Response) -> Response {
    return Response.init(
        status: response.status,
        headers: response.headers.takeUnretainedValue() as! [String : [Data]],
        body: response.body.takeUnretainedValue() as Data
    );
}

public func initLogger() {
    lightarti_rest.logger_init()
}
