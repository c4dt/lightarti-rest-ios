import arti_rest
import Foundation

public func getTLS(domain: String) -> String {
    return call_tls_get(domain).takeRetainedValue() as NSString as String;
}
