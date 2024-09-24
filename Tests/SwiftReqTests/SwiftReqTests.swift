import Foundation
import Testing

@testable import SwiftReq

@Test func example() async throws {
    let builder: SwiftReqBuilder = SwiftReqBuilder()
        .baseURL(URL(string: "https://jsonplaceholder.typicode.com")!)
        .baseHeaders([:])
    let swiftReq: SwiftReq = try! builder.build()

    let firstTodo: Request = try swiftReq
        .GET()
        .endpoint("/posts/1")
        .buildRequest()

        

    
}
