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
        return Observable.create { f in
            DispatchQueue.global().async {
                let url = URL(string: MEMBER_LIST_URL)!
                let data = try! Data(contentsOf: url)
                let json = String(data: data, encoding: .utf8)
                
                DispatchQueue.main.async {
                    f.onNext(json)
                }
            }
            
            return Disposables.create()
        }
    }

    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)

        downloadJson(MEMBER_LIST_URL)
            .subscribe { event in
                switch event {
                case .next(let json) :
                    self.editView.text = json
                    self.setVisibleWithAnimation(self.activityIndicator, false)
                    
                case .completed:
                    break
                case .error(_):
                    break
                }
            }
    }
}
