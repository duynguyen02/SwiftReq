import Alamofire
import Foundation

class Method {
    init(swiftReq: SwiftReq) {
        self.swiftReq = swiftReq
    }

    var swiftReq: SwiftReq
    var method: HTTPMethod = .get
    var endpoint: Endpoint = ""
    var parameters: Parameters = [:]
    var mapping: AnyClass? = nil

    func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    func endpoint(_ endpoint: String) -> Self {
        self.endpoint = endpoint
        return self
    }

    func parameter(for key: String, withValue value: String) -> Self {
        self.parameters[key] = value
        return self
    }

    func parameters(_ parameters: [String: String]) -> Self {
        self.parameters.merge(parameters) { current, _ in
            current
        }
        return self
    }

    private func getURLWithEndpoint() -> URL {
        var url: URL = self.swiftReq.baseURL
        url.appendPathComponent(self.endpoint)
        return url
    }

    func buildRequest() throws -> Request {
        let url = getURLWithEndpoint()

        let dataRequest: DataRequest = AF.request(
            url, method: self.method, parameters: self.parameters
        )

        return Request(
            dataRequest: dataRequest
        )
    }
}
