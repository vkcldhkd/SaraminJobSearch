//
//  DataResponser.swift
//  SaraminSearch
//
//  Created by Sung Hyun on 2018. 6. 27..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

import RxSwift
import SwiftyXMLParser

class DataResponser{
    
    class func getItemList(page : Int, keywords : String?) -> Observable<(items: [XML.Element], nextPage: Int?)> {
        let emptyTuple : ([XML.Element],Int?) = ([],nil)
        
        var url = Constants_apis.BASE_URL + "&start=\(page)"
        if let keywords = keywords, !keywords.isEmpty{
            url.append("&keywords=\(keywords)")
        }
        
        LogHelper.printLog("url : \(url)")
        
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return RequestManager.request(method: .get, url: encodedURL)
                .map{ xml -> ([XML.Element],Int?) in
                    guard let xml = xml else { return emptyTuple }
                    let jobs = xml["job-search", "jobs", "job"].all.map{ $0 }
                    guard let items = jobs else { return emptyTuple }
                    let nextPage = items.isEmpty ? nil : page + 1
                    return (items,nextPage)
                    
            }
        }else{
            return Observable.just(emptyTuple)
        }
    }
}
