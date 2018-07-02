//
//  File.swift
//  SaraminSearch
//
//  Created by Sung Hyun on 2018. 6. 27..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

//import Foundation
//import Alamofire
///**
// * API 통신을 하기위한 class
// */
//class RequestManager{
//    static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
//    static fileprivate let mainQueue = DispatchQueue.main
//
//    static let sharedManager: Alamofire.SessionManager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForResource = Constants.TIMEOUT_SECONDS
//        configuration.timeoutIntervalForRequest = Constants.TIMEOUT_SECONDS
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        return sessionManager
//    }()
//
//
//
//    /**
//     * response를 판단 후 clsoure 해주는 함수
//     */
//    fileprivate class func make(request: DataRequest, closure: @escaping (_ data : Data?, _ error: Error?)->()) {
//        request.responseData(queue: RequestManager.queue) { (response) in
//            switch response.result {
//            //실패할 경우
//            case .failure(let error):
//                RequestManager.mainQueue.async {
//                    closure(nil, error)
//                }
//
//            case .success(let data):
//                // 성공일 경우
//                RequestManager.mainQueue.async {
//                    closure(data, nil)
//                }
//            }
//        }
//    }
//
//    /**
//     * alamofire error check (internet 등)
//     */
//    class func errorChecker(_ error : Error?){
//        guard let error = error else { return }
//
//        LogHelper.printLog("error code : \(error._code)")
//    }
//
//    /**
//     * http method == get
//     */
//    class func request(url : String, param : Parameters = [:], closure: @escaping (_ data: Data?)->()) {
//        //        let request = self.sharedManager.request(url)
//        let request = self.sharedManager.request(url, method: .get, parameters: param)
//        RequestManager.make(request: request) { (data, error) in
//
//            self.errorChecker(error)
//            closure(data)
//        }
//    }
//}
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa
import SwiftyXMLParser

class RequestManager {
    static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = Constants.TIMEOUT_SECONDS
        configuration.timeoutIntervalForRequest = Constants.TIMEOUT_SECONDS
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
    
    class func request(method : HTTPMethod = .post, url : String) -> Observable<XML.Accessor?> {
        
        return RequestManager.sharedManager.rx.string(method, url)
            .retry(3)
            .observeOn(ConcurrentDispatchQueueScheduler(queue: .global()))
            .map{ xmlData -> (XML.Accessor?) in
//                LogHelper.printLog("xmlData : \(xmlData)")
                guard let xml = XMLHelper.createXML(data: xmlData) else { return nil}
                return xml
            }
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                    LogHelper.printLog("⚠️ Saramin API rate limit exceeded. Wait for 60 seconds and try again.")
                }else{
                    LogHelper.printLog("error : \(error.localizedDescription)")
                }
            })
            .catchErrorJustReturn(nil)
        
    }
}

