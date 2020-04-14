//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func exJust1() {
        Observable.just("Hello World")
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])    // 아이템 하나씩 내려감
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello")
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])    // stream
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        Observable.just("800x600")
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // 이 다음 줄 부터 영향
            //.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // 처음부터 .subscribe 까지 영향
            .map { $0.replacingOccurrences(of: "x", with: "/") }    // "800/600"
            .map { "https://picsum.photos/\($0)/?random" }  // "https://picsum.photos/800/600/?random"
            .map { URL(string: $0) }    // URL
            .filter { $0 != nil }   // nil 검사
            .map { $0! }    // 강제 언래핑
            .map { try Data(contentsOf: $0) }   // data
            .map { UIImage(data: $0) }  // UIImage?
            .observeOn(MainScheduler.instance)  // 메인 스케줄러에서 돌리기
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
