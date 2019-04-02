//
//  XMLHelper.swift
//  SaraminSearch
//
//  Created by Sung Hyun on 2018. 6. 28..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class XMLHelper {
    class func createXML(data : String) -> XML.Accessor? {
        return try? XML.parse(data)
    }
    
    class func createXML(data : Data) -> XML.Accessor? {
        return XML.parse(data)

    }
    
}
