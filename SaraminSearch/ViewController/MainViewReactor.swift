//
//  MainViewReactor.swift
//  SaraminSearch
//
//  Created by Sung Hyun on 2018. 6. 27..
//  Copyright © 2018년 Sung Hyun. All rights reserved.
//

import ReactorKit
import RxSwift
import SwiftyXMLParser

final class MainviewReactor: Reactor {
    enum Action {
        case loadNextPage
        case updateQuery(String?)
    }
    
    enum Mutation {
        case setQuery(String?)
        case setItems([XML.Element], nextPage: Int?)
        case appendItems([XML.Element], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var query: String?
        var nextPage : Int?
        var items : [XML.Element] = []
        var isLoadingNextPage: Bool = false
    }
    
    let initialState = State()
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.concat([
                // 1) set current state's query (.setQuery)
                Observable.just(Mutation.setQuery(query)),
                // 2) call API and set repos (.setRepos)
                DataResponser.getItemList(page: 1, keywords: query)
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map{ Mutation.setItems($0,nextPage: $1) },
                ])
            
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() } // prevent from multiple requests
            guard let page = self.currentState.nextPage else { return Observable.empty() }
//            LogHelper.printLog("self.currentState.page : \(self.currentState.nextPage)")
            
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                DataResponser.getItemList(page: page, keywords: self.currentState.query).filter { !$0.isEmpty && $0.count != 0 && $1 != 0 }.map{ Mutation.appendItems($0,nextPage: $1)},
                Observable.just(Mutation.setLoadingNextPage(false)),
                ])
        }
        
        
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            if query != nil && query!.count != 0 {
                newState.query = query
            }else{
                newState.items = []
            }
            return newState
            
        case let .setItems(items,page):
            var newState = state
            newState.items = items
            newState.nextPage = page
            return newState
            
        case let .appendItems(items,page) :
            var newState = state
            newState.items.append(contentsOf: items)
            newState.nextPage = page
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
    private func isUpdateQueryAction(_ action: Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}
