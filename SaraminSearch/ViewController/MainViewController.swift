//
//  ViewController.swift
//  SaraminJobSearch
//
//  Created by Sung Hyun on 2018. 6. 27..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemTableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = MainviewReactor()
        self.itemTableView.registers(cells: ["JobViewCell"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "사람인 검색"
    }
}

extension MainViewController : StoryboardView{
    func bind(reactor: MainviewReactor) {
        //action
        self.searchBar.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .filter{ $0 != nil && $0!.count > 0 && !$0!.containsEmoji }
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        
        self.itemTableView.rx.isReachedBottom
            .map { Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.items }
            .bind(to: self.itemTableView.rx.items(cellIdentifier: "JobViewCell", cellType: JobViewCell.self)) { indexPath, items, cell in
                
                for item in items.childElements{
                    switch item.name{
                    case "position":
                        cell.titleLabel.text = item.childElements[0].text ?? "empty"
                        cell.contentLabel.text = item.childElements[7].text ?? "empty"
                    default:
                        LogHelper.printLog("item : \(item.name)")
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }
}
