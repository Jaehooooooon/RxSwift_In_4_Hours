//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // @escaping 은 downloadJson이 끝나도 closure가 실행될 수 있게 OR closure가 옵셔널타입이라면 필요없음 (@escaping이 default)
    func downloadJson(_ url: String) -> Observable<String?> {
        return Observable.create() { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url) { ( data, _, err) in
                guard err == nil else {
                    emitter.onError(err!)
                    return
                }
                
                if let data = data, let json = String(data: data, encoding: .utf8) {
                    emitter.onNext(json)
                }
                
                emitter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
        
//        return Observable.create { f in
//            DispatchQueue.global().async {
//                let url = URL(string: MEMBER_LIST_URL)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//
//                DispatchQueue.main.async {
//                    f.onNext(json)
//                    f.onCompleted() // closure 종료 - 순환참조 문제 해결
//                }
//            }
//
//            return Disposables.create()
//        }
    }

    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)
 
        // 2. Observable로 오는 데이터 처리하는 방법
        downloadJson(MEMBER_LIST_URL)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))  // 시작 스레드
            .observeOn(MainScheduler.instance)  // 다음 줄부터 실행할 스레드
            .subscribe(onNext: { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
    }
}
