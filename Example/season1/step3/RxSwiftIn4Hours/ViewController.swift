//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
        
        // input
        let idInputOb = idField.rx.text.orEmpty.asObservable()
        let idValidOb = idInputOb.map(checkEmailValid)
        
        let pwInputOb = pwField.rx.text.orEmpty.asObservable()
        let pwValidOb = pwInputOb.map(checkPasswordValid)
        
        // output
        idValidOb.subscribe(onNext: { b in self.idValidView.isHidden = b })
            .disposed(by: disposeBag)
        
        pwValidOb.subscribe(onNext: { b in self.pwValidView.isHidden = b })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(idValidOb, pwValidOb, resultSelector: { $0 && $1 })
            .subscribe(onNext: { b in self.loginButton.isEnabled = b })
            .disposed(by: disposeBag)
        
//        idField.rx.text.orEmpty // orEmpty 언래핑 해줌
////            .filter { $0 != nil }
////            .map { $0! }
//            .map(checkEmailValid)
//            .subscribe(onNext: { b in
//                self.idValidView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        pwField.rx.text.orEmpty
//            .map(checkPasswordValid)
//            .subscribe(onNext: { b in
//                self.pwValidView.isHidden = b
//            })
//            .disposed(by: disposeBag)
//
//        Observable.combineLatest(
//            idField.rx.text.orEmpty.map(checkEmailValid),
//            pwField.rx.text.orEmpty.map(checkPasswordValid),
//            resultSelector: { s1, s2 in s1 && s2 }
//        )
//            .subscribe(onNext: { b in
//                self.loginButton.isEnabled = b
//            })
//            .disposed(by: disposeBag)
        
        
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
