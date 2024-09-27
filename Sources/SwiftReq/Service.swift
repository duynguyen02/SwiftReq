import Alamofire
import Foundation

public class Response<T: Decodable> {
    internal init(
        isSuccessful: Bool? = nil, statusCode: Int? = nil, body: T? = nil, error: String? = nil
    ) {
        self.isSuccessful = isSuccessful
        self.statusCode = statusCode
        self.body = body
        self.error = error
    }

    let isSuccessful: Bool?
    let statusCode: Int?
    let body: T?
    let error: String?
}

public class ServiceBuilder<T: Decodable> {
    public init(swiftReq: SwiftReq, endpoint: Endpoint) {
        self.swiftReq = swiftReq
        self.endpoint = endpoint
    }

    private let swiftReq: SwiftReq
    private let endpoint: Endpoint
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var parameters: [String: String] = [:]

    @discardableResult
    public func setMethod(_ method: HTTPMethod) -> ServiceBuilder {
        self.method = method
        return self
    }

    @discardableResult
    public func setHeaders(_ headers: [String: String]) -> ServiceBuilder {
        self.headers = headers
        return self
    }

    @discardableResult
    public func addHeader(key: String, value: String) -> ServiceBuilder {
        self.headers[key] = value
        return self
    }

    @discardableResult
    public func setParameters(_ parameters: [String: String]) -> ServiceBuilder {
        self.parameters = parameters
        return self
    }

    @discardableResult
    public func addParameter(key: String, value: String) -> ServiceBuilder {
        self.parameters[key] = value
        return self
    }

    private func getURLWithEndpoint() -> URL {
        var url: URL = swiftReq.host
        url.appendPathComponent(self.endpoint)
        return url
    }

    private func getAllParameters() -> Parameters {
        var requestParams: Parameters = parameters
        requestParams.merge(swiftReq.parameters) { current, _ in
            current
        }
        return parameters
    }

    private func getAllHeaders() -> Headers {
        var requestHeaders: Headers = headers
        requestHeaders.merge(swiftReq.headers) { current, _ in
            current
        }
        return requestHeaders
    }

    private func build() -> DataRequest {
        let url: URL = getURLWithEndpoint()
        let parameters: Parameters = getAllParameters()
        let headers: Headers = getAllHeaders()

        return Alamofire.AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: HTTPHeaders(headers),
            interceptor: swiftReq.requestInterceptor
        ) { request in
            request.timeoutInterval = self.swiftReq.timeout
        }
    }

    func request() async throws -> T {
        return try await build().serializingDecodable(T.self).value
    }

    func response() async throws -> Response<T> {
        let response: DataResponse<T, AFError> = await build().serializingDecodable(T.self).response

        var isSuccessful: Bool = false
        if let statusCode: Int = response.response?.statusCode{
            isSuccessful = (200..<300).contains(statusCode)
        }

        var error: String? = nil
        if let data: Data = response.data{
            error = String(decoding: data, as: UTF8.self)
        }

        return Response<T>(
            isSuccessful: isSuccessful,
            statusCode: response.response?.statusCode,
            body: response.value,
            error: error
        )
    }

}

class Method<T: Decodable>: ServiceBuilder<T> {
    init(swiftReq: SwiftReq, endpoint: Endpoint, method: HTTPMethod) {
        super.init(swiftReq: swiftReq, endpoint: endpoint)
        setMethod(method)
    }
}

class Get<T: Decodable>: Method<T> {
    init(swiftReq: SwiftReq, endpoint: Endpoint) {
        super.init(swiftReq: swiftReq, endpoint: endpoint, method: .get)
    }
}

class Post<T: Decodable>: Method<T> {
    init(swiftReq: SwiftReq, endpoint: Endpoint) {
        super.init(swiftReq: swiftReq, endpoint: endpoint, method: .post)
    }
}

class Put<T: Decodable>: Method<T> {
    init(swiftReq: SwiftReq, endpoint: Endpoint) {
        super.init(swiftReq: swiftReq, endpoint: endpoint, method: .put)
    }
}

class Delete<T: Decodable>: Method<T> {
    init(swiftReq: SwiftReq, endpoint: Endpoint) {
        super.init(swiftReq: swiftReq, endpoint: endpoint, method: .delete)
    }
}
