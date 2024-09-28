import Alamofire
import XCTest

@testable import SwiftReq

final class ServiceBuilderTests: XCTestCase {

    let host = URL(string: "https://jsonplaceholder.typicode.com")!
    var swiftReq: SwiftReq!

    override func setUp() {
        super.setUp()
        swiftReq = SwiftReqBuilder(host: host).build()
    }

    func testGetTodo() async throws {
        let endpoint: String = "/todos/1"
        let getRequest: Service<Todo> = get(swiftReq: swiftReq, endpoint: endpoint)
            .service()

        getRequest.build().cURLDescription { desc in
            print(desc)
        }

        let response = try await getRequest.response()

        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.id, 1)
        XCTAssertEqual(response.body?.title, "delectus aut autem")
        XCTAssert(response.isSuccessful == true)
    }

    func testCreateTodoByURLEncodedFormDataService() async throws {
        let endpoint = "/todos"
        let postRequest: Service<Todo> = post(swiftReq: swiftReq, endpoint: endpoint)
            .urlEncodedFormDataService()
            .addParameter((key: "title", value: "foo"))
            .addParameter((key: "body", value: "bar"))
            .addParameter((key: "userId", value: "1"))

        postRequest.build().cURLDescription { desc in
            print(desc)
        }

        let response = try await postRequest.response()

        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.title, "foo")
        XCTAssert(response.isSuccessful == true)
    }

    func testCreateTodoByJSONBodyService() async throws {
        let endpoint = "/todos"
        let postRequest: Service<Todo> = post(swiftReq: swiftReq, endpoint: endpoint)
            .jsonBodyService()
            .setBody(
                TodoCreate(title: "foo", body: "bar", userId: 1)
            )

        postRequest.build().cURLDescription { desc in
            print(desc)
        }

        let response = try await postRequest.response()

        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.title, "foo")
        XCTAssert(response.isSuccessful == true)
    }

    func testCreateTodoByMultipartFormDataService() async throws {
        let endpoint = "/todos"
        let postRequest: Service<Todo> = post(swiftReq: swiftReq, endpoint: endpoint)
            .multipartFormDataService()
            .addFormField(
                ("title", "foo".data(using: .utf8, allowLossyConversion: false)!)
            )
            .addFormField(
                ("body", "bar".data(using: .utf8, allowLossyConversion: false)!)
            )
            .addFormField(
                ("userId", "1".data(using: .utf8, allowLossyConversion: false)!)
            )

        postRequest.build().cURLDescription { desc in
            print(desc)
        }
    
        let response = try await postRequest.response()

        XCTAssertNotNil(response.body)
        XCTAssertEqual(response.body?.title, "foo")
        XCTAssert(response.isSuccessful == true)
    }

    func testUpdateTodo() async throws {
        let endpoint = "/todos/1"
        let putRequest: Service<Todo> = put(swiftReq: swiftReq, endpoint: endpoint)
            .urlEncodedFormDataService()
            .addParameter((key: "title", value: "updated title"))

        putRequest.build().cURLDescription { desc in
            print(desc)
        }

        let response = try await putRequest.response()

        XCTAssertNotNil(response.error)
        XCTAssert(response.isSuccessful == true)  // can not convert to class
    }

    func testDeleteTodo() async throws {
        let endpoint = "/todos/1"
        let deleteRequest: Service<Todo> = delete(swiftReq: swiftReq, endpoint: endpoint)
            .service()

        deleteRequest.build().cURLDescription { desc in
            print(desc)
        }
            
        let response = try await deleteRequest.response()
        

        XCTAssertNil(response.body)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssert(response.isSuccessful == true)
    }
}

struct Todo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct TodoCreate: Encodable {
    let title: String
    let body: String
    let userId: Int
}
