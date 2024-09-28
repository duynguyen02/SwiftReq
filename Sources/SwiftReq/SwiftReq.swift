import Alamofire
import Foundation

public class SwiftReqBuilder {
    public init(host: URL) {
        self.host = host
    }

    private let host: URL
    private var headers: [String: String] = [:]
    private var timeout: TimeInterval = 10.0
    private var requestInterceptor: RequestInterceptor? = nil

    @discardableResult
    public func setHeaders(_ headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }

    @discardableResult
    public func addHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }

    @discardableResult
    public func setTimeout(_ timeout: TimeInterval) -> Self {
        self.timeout = timeout
        return self
    }

    @discardableResult
    public func setRequestInterceptor(_ requestInterceptor: RequestInterceptor) -> Self {
        self.requestInterceptor = requestInterceptor
        return self
    }

    public func build() -> SwiftReq {
        return SwiftReq(
            host: host, headers: headers,
            timeout: timeout,
            requestInterceptor: requestInterceptor
        )
    }
}

public class SwiftReq {
    internal init(
        host: URL, headers: [String: String],
        timeout: TimeInterval,
        requestInterceptor: RequestInterceptor?
    ) {
        self.host = host
        self.headers = headers
        self.timeout = timeout
        self.requestInterceptor = requestInterceptor
    }

    public let host: URL
    public let headers: [String: String]
    public let timeout: TimeInterval
    public let requestInterceptor: RequestInterceptor?

}
