import Alamofire
import Foundation

class SwiftReq {
    init(baseURL: URL, baseHeaders: [String: String]? = nil) {
        self.baseURL = baseURL
        self.baseHeaders = baseHeaders
    }

    var baseURL: URL
    let baseHeaders: [String: String]?

    func GET() -> Get {
        return Get(swiftReq: self)
    }

}

class SwiftReqBuilder {
    var baseURL: URL? = nil
    var baseHeaders: [String: String]? = nil

    func baseURL(_ url: URL) -> SwiftReqBuilder {
        self.baseURL = url
        return self
    }

    func baseHeaders(_ headers: [String: String]) -> SwiftReqBuilder {
        self.baseHeaders = headers
        return self
    }

    func build() throws -> SwiftReq {
        guard let baseURL = baseURL else {
            throw SwiftReqError.swiftReqBuildingError(message: "Base URL is required.")
        }
        return SwiftReq(baseURL: baseURL, baseHeaders: baseHeaders)
    }

}
