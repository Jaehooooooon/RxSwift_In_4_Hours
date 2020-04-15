//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 서재훈 on 2020/04/15.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        let menus: [Menu] = [
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김2", price: 100, count: 0),
            Menu(name: "튀김3", price: 100, count: 0),
            Menu(name: "튀김4", price: 100, count: 0)
        ]
        
        menuObservable.onNext(menus)
    }
    
    func clearAllItemSelections() {
        menuObservable
            .map { menus in
                return menus.map { m in
                    Menu(name: m.name, price: m.price, count: 0)
                }
            }
            .take(1)    // clear할 때마다 stream이 생성되지 않도록
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}
