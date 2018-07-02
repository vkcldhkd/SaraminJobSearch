//
//  UITableView.swift
//  SaraminSearch
//
//  Created by Sung Hyun on 2018. 6. 27..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

import UIKit

extension UITableView{
    func registers(cells : [String]){
        
        _ = cells.map{ self.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0) }
        
    }
}
