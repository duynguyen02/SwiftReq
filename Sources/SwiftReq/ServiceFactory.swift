import Alamofire

public class ServiceFactory<T: Decodable> {
    public init(swiftReq: SwiftReq, endpoint: Endpoint, method: HTTPMethod) {
        self.swiftReq = swiftReq
        self.endpoint = endpoint
        self.method = method
    }

    private let swiftReq: SwiftReq
    private let endpoint: Endpoint
    private let method: HTTPMethod

    public func service() -> Service<T> {
        return Service<T>(swiftReq: swiftReq, endpoint: endpoint)
            .setMethod(method)
    }

    public func urlEncodedFormDataService() -> URLEncodedFormDataService<T>{
        return URLEncodedFormDataService<T>(swiftReq: swiftReq, endpoint: endpoint)
            .setMethod(method)
    }

    public func multipartFormDataService() -> MultipartFormDataService<T>{
        return MultipartFormDataService<T>(swiftReq: swiftReq, endpoint: endpoint)
            .setMethod(method)
    }

    public func jsonBodyService<E>() -> JSONBodyService<T,E>{
        return JSONBodyService<T,E>(swiftReq: swiftReq, endpoint: endpoint)
            .setMethod(method)
    }

}


public func factory<T>(swiftReq: SwiftReq, endpoint: Endpoint, method: HTTPMethod = .get) -> ServiceFactory<T>{
    return ServiceFactory(
        swiftReq: swiftReq, endpoint: endpoint, method: method
    )
}

public func get<T>(swiftReq: SwiftReq, endpoint: Endpoint) -> ServiceFactory<T> {
    return factory(
        swiftReq: swiftReq, endpoint: endpoint, method: .get
    )
}

public func post<T>(swiftReq: SwiftReq, endpoint: Endpoint) -> ServiceFactory<T> {
    return factory(
        swiftReq: swiftReq, endpoint: endpoint, method: .post
    )
}

public func put<T>(swiftReq: SwiftReq, endpoint: Endpoint) -> ServiceFactory<T> {
    return factory(
        swiftReq: swiftReq, endpoint: endpoint, method: .put
    )
}

public func patch<T>(swiftReq: SwiftReq, endpoint: Endpoint) -> ServiceFactory<T> {
    return factory(
        swiftReq: swiftReq, endpoint: endpoint, method: .patch
    )
}

public func delete<T>(swiftReq: SwiftReq, endpoint: Endpoint) -> ServiceFactory<T> {
    return factory(
        swiftReq: swiftReq, endpoint: endpoint, method: .delete
    )
}