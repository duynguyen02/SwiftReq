import Foundation
import Testing

@testable import SwiftReq

struct Todo: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

@Test func simpleRequest() async throws {
    let swiftReq = SwiftReqBuilder(host: URL(string: "https://jsonplaceholder.typicode.com")!)
        .setTimeout(5.0)
        .build()

    let post: Get<[Todo]> = Get<[Todo]>(swiftReq: swiftReq, endpoint: "/todos")
    print(try await post.request()[0].title)
    // print(try await post.request()[0].title)

}

// @Test func simpleResponse() async throws {
//     let swiftReq = SwiftReqBuilder(host: URL(string: "https://jsonplaceholder.typicode.com")!)
//         .setTimeout(5.0)
//         .build()
//     let post: Get<Todo> = Get<Todo>(swiftReq: swiftReq, endpoint: "/posts/1")
//     print(try await post.response().body ?? "NULL")
// }
