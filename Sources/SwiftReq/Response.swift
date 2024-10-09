public class Response<T: Decodable> {
    internal init(
        isSuccessful: Bool? = nil, statusCode: Int? = nil, body: T? = nil, error: String? = nil
    ) {
        self.isSuccessful = isSuccessful
        self.statusCode = statusCode
        self.body = body
        self.error = error
    }

    public let isSuccessful: Bool?
    public let statusCode: Int?
    public let body: T?
    public let error: String?
}