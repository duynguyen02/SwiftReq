import Alamofire
import Foundation

public class SwiftReqBuilder {
    public init(host: URL) {
        self.host = host
    }

    private let host: URL
    private var headers: [String: String] = [:]
    private var parameters: [String: String] = [:]
    private var timeout: TimeInterval = 10.0
    private var requestInterceptor: RequestInterceptor? = nil

    @discardableResult
    public func setHeaders(_ headers: [String: String]) -> SwiftReqBuilder {
        self.headers = headers
        return self
    }

    @discardableResult
    public func addHeader(key: String, value: String) -> SwiftReqBuilder {
        self.headers[key] = value
        return self
    }

    @discardableResult
    public func setParameters(_ parameters: [String: String]) -> SwiftReqBuilder {
        self.parameters = parameters
        return self
    }

    @discardableResult
    public func addParameter(key: String, value: String) -> SwiftReqBuilder {
        self.parameters[key] = value
        return self
    }

    @discardableResult
    public func setTimeout(_ timeout: TimeInterval) -> SwiftReqBuilder {
        self.timeout = timeout
        return self
    }

    @discardableResult
    public func setRequestInterceptor(_ requestInterceptor: RequestInterceptor) -> SwiftReqBuilder {
        self.requestInterceptor = requestInterceptor
        return self
    }

    public func build() -> SwiftReq {
        return SwiftReq(
            host: host, headers: headers,
            parameters: parameters, timeout: timeout,
            requestInterceptor: requestInterceptor
        )
    }
}

public class SwiftReq {
    internal init(
        host: URL, headers: [String: String],
        parameters: [String: String], timeout: TimeInterval,
        requestInterceptor: RequestInterceptor?
    ) {
        self.host = host
        self.headers = headers
        self.parameters = parameters
        self.timeout = timeout
        self.requestInterceptor = requestInterceptor
    }

    public let host: URL
    public let headers: [String: String]
    public let parameters: [String: String]
    public let timeout: TimeInterval
    public let requestInterceptor: RequestInterceptor?

}
