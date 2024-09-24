import Alamofire
import Foundation

class Request {

    init(dataRequest: DataRequest) {
        self.dataRequest = dataRequest
    }

    private let dataRequest: DataRequest

    func requestAsString(){
        dataRequest.responseString { responseString in
            
        }
    }

}
