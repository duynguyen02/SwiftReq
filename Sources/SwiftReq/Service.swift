import Alamofire
import Foundation

public class Service<T: Decodable> {
    public init(swiftReq: SwiftReq, endpoint: Endpoint) {
        self.swiftReq = swiftReq
        self.endpoint = endpoint
    }

    fileprivate let swiftReq: SwiftReq
    fileprivate let endpoint: Endpoint
    fileprivate var queries: [Query] = []
    fileprivate var method: HTTPMethod = .get
    fileprivate var headers: [String: String] = [:]

    @discardableResult
    public func setMethod(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    @discardableResult
    public func setQueries(_ queries: [Query]) -> Self {
        self.queries = queries
        return self
    }

    @discardableResult
    public func addQuery(_ query: Query) -> Self {
        self.queries.append(query)
        return self
    }

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

    fileprivate func getURLWithQueries(url: URL) -> URL {
        if queries.count == 0 {
            return url
        }
        var urlComponents: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let queryParams: [URLQueryItem] = queries.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryParams
        return urlComponents.url!
    }

    fileprivate func getURLWithEndpointAndQueries() -> URL {
        var url: URL = swiftReq.host
        url.appendPathComponent(self.endpoint)
        url = getURLWithQueries(url: url)
        return url
    }

    fileprivate func getAllHeaders() -> Headers {
        var requestHeaders: Headers = headers
        requestHeaders.merge(swiftReq.headers) { current, _ in
            current
        }
        return requestHeaders
    }

    public func build() -> DataRequest {
        let url: URL = getURLWithEndpointAndQueries()
        let headers: Headers = getAllHeaders()

        return Alamofire.AF.request(
            url,
            method: method,
            headers: HTTPHeaders(headers),
            interceptor: swiftReq.requestInterceptor
        ) { request in
            request.timeoutInterval = self.swiftReq.timeout
        }

    }

    @available(macOS 10.15, *)
    public func publisher() -> DataResponsePublisher<T>{
        return build().publishDecodable(type: T.self, decoder: swiftReq.dataDecoder)
    }

    @available(macOS 10.15, *)
    public func request() async throws -> T {
        return try await build().serializingDecodable(T.self, decoder: swiftReq.dataDecoder).value
    }

    @available(macOS 10.15, *)
    public func response() async throws -> Response<T> {
        let response: DataResponse<T, AFError> = await build().serializingDecodable(T.self, decoder: swiftReq.dataDecoder).response

        var isSuccessful: Bool = false
        if let statusCode: Int = response.response?.statusCode {
            isSuccessful = (200..<300).contains(statusCode)
        }

        var error: String? = nil
        if response.data != nil && (!isSuccessful || response.value == nil){
            let data: Data = response.data!
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


public class URLEncodedFormDataService<T: Decodable>: Service<T> {

    fileprivate var parameters: Parameters? = nil
    fileprivate var encoder: URLEncodedFormParameterEncoder = URLEncodedFormParameterEncoder.default

    @discardableResult
    public func setParameters(_ parameters: Parameters) -> Self {
        self.parameters = parameters
        return self
    }

    @discardableResult
    public func addParameter(_ parameter: (key: String, value: String)) -> Self {
        if self.parameters == nil {
            self.parameters = [:]
        }
        self.parameters?[parameter.key] = parameter.value
        return self
    }

    @discardableResult
    public func setEncoder(_ encoder: URLEncodedFormParameterEncoder) -> Self {
        self.encoder = encoder
        return self
    }

    public override func build() -> DataRequest {
        let url: URL = getURLWithEndpointAndQueries()
        let headers: Headers = getAllHeaders()

        return Alamofire.AF.request(
            url,
            method: method,
            parameters: parameters,
            encoder: encoder,
            headers: HTTPHeaders(headers),
            interceptor: swiftReq.requestInterceptor
        ) { request in
            request.timeoutInterval = self.swiftReq.timeout
        }
    }
}

public class MultipartFormDataService<T: Decodable>: Service<T> {

    fileprivate var formFields: FormFields = [:]
    fileprivate var multipartFormDataModifier: ((MultipartFormData) -> Void)? = nil

    @discardableResult
    public func setFormFields(_ formFields: FormFields) -> Self {
        self.formFields = formFields
        return self
    }


    @discardableResult
    public func multipartFormDataModifier(_ modifier: @escaping ((MultipartFormData) -> Void)) -> Self{
        self.multipartFormDataModifier = multipartFormDataModifier
        return self
    }


    @discardableResult
    public func addFormField(_ formField: (String, Data)) -> Self {
        self.formFields[formField.0] = formField.1
        return self
    }

    public override func build() -> DataRequest {
        let url: URL = getURLWithEndpointAndQueries()
        let headers: Headers = getAllHeaders()

        return Alamofire.AF.upload(
            multipartFormData: { fd in
                self.formFields.forEach { fd.append($1, withName: $0) }
                self.multipartFormDataModifier?(fd)
            }, to: url,
            method: method,
            headers: HTTPHeaders(headers),
            interceptor: swiftReq.requestInterceptor
        ) { request in
            request.timeoutInterval = self.swiftReq.timeout
        }
    }
}


public class JSONBodyService<T: Decodable, E: Encodable>: Service<T> {
    fileprivate var body: E? = nil
    fileprivate var encoder: JSONParameterEncoder = JSONParameterEncoder.default

    @discardableResult
    public func setBody(_ body: E) -> Self {
        self.body = body
        return self
    }

    @discardableResult
    public func setEncoder(_ encoder: JSONParameterEncoder) -> Self {
        self.encoder = encoder
        return self
    }

    public override func build() -> DataRequest {
        let url: URL = getURLWithEndpointAndQueries()
        let headers: Headers = getAllHeaders()
        
        guard let body: E = self.body else {
            fatalError("Body must be set before calling build().")
        }

        return Alamofire.AF.request(
            url,
            method: method,
            parameters: body,
            encoder: self.encoder,
            headers: HTTPHeaders(headers),
            interceptor: swiftReq.requestInterceptor
        ) { request in
            request.timeoutInterval = self.swiftReq.timeout
        }
    }
}
